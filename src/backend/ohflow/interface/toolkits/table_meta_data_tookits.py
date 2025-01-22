"""Toolkit for interacting with an SQL database."""
import json
from typing import List
from typing import Any, Dict, Optional, Sequence, Type, Union

from langchain_core.language_models import BaseLanguageModel
from langchain_core.prompt_values import ChatPromptValue, StringPromptValue
from langchain_openai import OpenAI
from pydantic import BaseModel, Field, root_validator, model_validator, ConfigDict, FilePath
from langchain_core.tools import BaseToolkit

from langchain_core.output_parsers.transform import BaseTransformOutputParser
from langchain_core.callbacks import (
    AsyncCallbackManagerForToolRun,
    CallbackManagerForToolRun, CallbackManagerForChainRun,
)
from langchain.chains.base import Chain
from langchain_community.tools import BaseTool
from langchain_community.tools.sql_database.tool import BaseSQLDatabaseTool
from langchain_community.utilities.sql_database import SQLDatabase
import ohflow.interface.agents.std_tables_data as meta_data
from langflow.field_typing import LanguageModel

class _InfoSQLDatabaseToolInput(BaseModel):
    table_name: str = Field(...,description=(
            "The ods table name for which to return the std table name. "
        ),
    )

class _FieldListSQLDataBaseToolInput(BaseModel):
    table_name: str = Field(...,description=(
                "The ods source table name for which to mapping his fields. "
            ),
        )
    field_name: str = Field(..., description="The table filed name for which to return the std field name.")
    std_table_name: str = Field(...,description=(
                "The target table name for which to return the field of this table. "
            ),
        )

class MappingSQLDatabaseTableTool(BaseSQLDatabaseTool, BaseTool):  # type: ignore[override, override]
    """Tool for getting std tables names."""

    name: str = "db_mapping_table"
    description: str = "Input is an ods table name, output is a std table name in the std database."
    args_schema: Type[BaseModel] = _InfoSQLDatabaseToolInput

    def _run(
            self,
            table_name: str,
            run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Get a comma-separated list of table names."""
        return meta_data.table_mapping_question(table_name)['prompt']


class MappingSQLDatabaseFieldTool(BaseSQLDatabaseTool, BaseTool):  # type: ignore[override, override]
    """Tool for getting metadata about a SQL database."""
    name: str = "db_mapping_field"
    description: str = "Input is an ods table name and one of his field, output is a table name in the std database."
    args_schema: Type[BaseModel] = _InfoSQLDatabaseToolInput

    def _run(
            self,
            table_name: str,
            field_name: str,
            std_table_name: str,
            run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Get the schema for tables in a comma-separated list."""
        return meta_data.field_mapping_question(table_name,field_name,std_table_name)['prompt']


class ColumenStrOutputParser(BaseTransformOutputParser[str]):
    """OutputParser that parses LLMResult into the top likely string."""

    @classmethod
    def is_lc_serializable(cls) -> bool:
        """Return whether this class is serializable."""
        return True

    @classmethod
    def get_lc_namespace(cls) -> List[str]:
        """Get the namespace of the langchain object."""
        return ["langchain", "schema", "output_parser"]

    @property
    def _type(self) -> str:
        """Return the output parser type for serialization."""
        return "default"

    def parse(self, text: str) -> List[str]:
        """Returns the input text with no changes."""
        tables = []
        for table in meta_data.std_tables.keys():
            if table in text:
                tables.append(table)
        return tables

    def parseColumns(self, text: str, std_tables: list) -> List[str]:
        """Returns the input text with no changes."""
        columns = []
        if text[0]=='无' or text[-1]=='无':
            return []

        for std_table_name in std_tables:
            std_table = meta_data.std_tables[std_table_name]
            for column in std_table['fields'].keys():
                pos = text.find("**"+column+"**")
                if pos>=0:
                    columns.append((pos,std_table_name+'.'+column))

        if len(columns)==0:
            for std_table_name in std_tables:
                std_table = meta_data.std_tables[std_table_name]
                for column_data in std_table['fields'].values():
                    column = column_data['data_name_en']
                    pos = text.find("**"+column+"**")
                    if pos>=0:
                        columns.append((pos,std_table_name+'.'+column_data['data_name_cn']))
        return columns


class CustomTableMappingChain(Chain):
    """Chain for getting the schema of a SQL database."""
    llm: BaseLanguageModel = Field(default=None)
    output_parser: ColumenStrOutputParser = Field(
        default_factory=lambda: ColumenStrOutputParser()
    )
    table_prompt_prefix: str = Field(
        default="库表映射任务，根据所给的标准库的表列表信息，找到最能将用户输入表映射上的表，可以多选，找不到则回答无",
        description="A prompt template to use for the table mapping prefix.",
    )
    field_prompt_prefix: str = Field(
        default="",
        description="A prompt template to use for the field mapping prefix.",
    )
    @property
    def input_keys(self):
        return ["input"]

    @property
    def output_keys(self):
        return ["output_data","output"]

    def _call(self, inputs:Dict, run_manager: Optional[CallbackManagerForChainRun] = None):
        # 只输入表名,表名.字段名, 表名->标化表名
        inputChatPromptValue = inputs["input"]
        if isinstance(inputChatPromptValue, ChatPromptValue):
            inputChatPromptValue = inputChatPromptValue.to_messages()[0].content
        input = inputChatPromptValue.strip().split('.')
        output = dict()
        if(1==len(input)):
            tables = input[0].split('->')
            if(len(tables)==1):
                table = input[0]
                std_table = self.table_mapping(table)
            else:
                table,std_table = tables
                std_table = std_table.strip().split(',')
            output['std_table'] = std_table
            fields = self.get_ods_table_fields(table)
            for field in fields:
                output[field['data_name_cn']] = self.field_mapping(table,field,std_table)

            # 字段映射
        if(2==len(input)):
            table = input[0]
            field = input[1]
            std_table = self.table_mapping(table)
            std_field = self.field_mapping(table,field,std_table)
            output['std_table'] = std_table
            output[field] = std_field

        if(3==len(input)):
            schema = input[0]
            table = input[0]+'.'+input[1]
            field = input[2]
            std_table = self.table_mapping(table)
            std_field = self.field_mapping(table,field,std_table)
            output['std_table'] = std_table
            output[field] = std_field

        return {"output_data": output, "output": json.dumps(output, indent=4, ensure_ascii=False)}

    def get_ods_table_fields(self, table_name: str) -> List[Dict]:
        ods_table = meta_data.ods_tables.get(table_name,None)
        if ods_table is None:
            return []
        return ods_table['fields'].values()
    def table_mapping(self, table_name: str) -> List[str]:
        prompt = meta_data.table_mapping_question(table_name)['prompt']
        output = self.llm.invoke(StringPromptValue(text=self.table_prompt_prefix+prompt)).content
        return self.output_parser.parse(output)

    def field_mapping(self, table_name: str, field_name: str,std_table:List[str]) -> List[str]:
        if not meta_data.use_field_desc or len(std_table)<=2:
            prompt = meta_data.field_mapping_question(table_name,field_name,std_table)['prompt']
            output = self.llm.invoke(StringPromptValue(text=self.field_prompt_prefix+prompt)).content
            return self.output_parser.parseColumns(output,std_table)
        else:
            colmus = []
            for std_tab in std_table:
                prompt = meta_data.field_mapping_question(table_name,field_name,std_tab)['prompt']
                output = self.llm.invoke(StringPromptValue(text=prompt)).content
                cols = self.output_parser.parseColumns(output,std_table)
                colmus+=cols
            return colmus



class DremioMetaDataToolkit(BaseToolkit):
    """Toolkit for interacting with remote SQL databases.

    Parameters:
        db: SQLDatabase. The SQL database.
        llm: BaseLanguageModel. The language model.
    """

    db: SQLDatabase = Field(exclude=True)

    @property
    def dialect(self) -> str:
        """Return string representation of SQL dialect to use."""
        return self.db.dialect

    class Config:
        """Configuration for this pydantic object."""

        arbitrary_types_allowed = True

    def get_tools(self) -> List[BaseTool]:
        """Get the tools in the toolkit."""

        db_mapping_table = MappingSQLDatabaseTableTool(
            db=self.db
        )

        db_mapping_field = MappingSQLDatabaseFieldTool(
            db=self.db
        )

        return [
            db_mapping_table,
            db_mapping_field,
        ]

    def get_context(self) -> dict:
        """Return db context that you may want in agent prompt."""
        return self.db.get_context()

