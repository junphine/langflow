"""Toolkit for interacting with an SQL database."""
import csv
import json,re
from pathlib import Path
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
from ohflow.interface.toolkits.table_meta_data_prompt import MetaDataMappingPrompt
from ohflow.interface.toolkits.table_meta_data_tookits import DremioMetaDataToolkit


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

    def parse(self, text: str,meta_data) -> List[str]:
        """Returns the input text with no changes."""
        tables = {}
        for table in meta_data.std_tables():
            if table in text:
                cn_name = meta_data.target_table_comments.get(table.upper(), "")
                tables[table] = cn_name
        return tables

    def parseColumns(self, text: str, std_tables: list,meta_data) -> List[str]:
        """text is markdown table format"""
        if len(text)<10:
            return []

        parsed_data = []

        # 使用正则表达式提取表格内容
        # 表格的列标题
        r = re.search(r'\|(.+?)\|\n', text)
        columns = r.group(1).split('|')
        columns = [col.strip() for col in columns if col.strip()]
        text = text[r.span()[1]:]
        # 表格的行数据
        rows = re.findall(r'\n\|(.+)\|', text)

        # 解析每一行数据
        for row in rows:
            # 分割每一行的字段
            fields = row.split('|')
            fields = [field.strip() for field in fields if field.strip()]

            # 将字段与列标题对应起来
            row_data = {}
            for col, field in zip(columns, fields):
                row_data[col] = field

            # 添加到结果列表中
            parsed_data.append(row_data)
        return parsed_data


class CustomTableMappingChain(Chain):
    """Chain for getting the schema of a SQL database."""
    llm: BaseLanguageModel = Field(default=None)
    source_toolkit: Optional[DremioMetaDataToolkit] = Field(default=None)
    target_toolkit: Optional[DremioMetaDataToolkit] = Field(default=None)
    output_parser: ColumenStrOutputParser = Field(
        default_factory=lambda: ColumenStrOutputParser()
    )
    table_prompt_prefix: str = Field(
        default="库表映射任务，根据所给的标准库的表列表信息，找到最能将用户输入表映射上的表，可以多选，找不到则回答无",
        description="A prompt template to use for the table mapping prefix.",
    )
    field_prompt_prefix: str = Field(
        default="从所给标准库的表字段中选出与用户输入业务表的字段可以映射的字段，只需返回字段中文名，允许多选，若无匹配字段，则回答无，返回格式为table类型，包含列（输入字段中文名，标准表中文名，标准字段中文名）。",
        description="A prompt template to use for the field mapping prefix.",
    )

    @property
    def input_keys(self):
        return ["input"]

    @property
    def meta_data(self)->MetaDataMappingPrompt:
        if not hasattr(self,'_meta_data'):
            self._meta_data = MetaDataMappingPrompt(self.source_toolkit,self.target_toolkit,False)
        return self._meta_data

    @property
    def output_keys(self):
        return ["output_data","output"]

    def _call(self, inputs:Dict, run_manager: Optional[CallbackManagerForChainRun] = None):
        # 只输入表名, 表名->标化表名
        inputChatPromptValue = inputs["input"]
        if isinstance(inputChatPromptValue, ChatPromptValue):
            inputChatPromptValue = inputChatPromptValue.to_messages()[0].content
        input = inputChatPromptValue.strip().split('->')
        output = dict()
        if(1==len(input)):
            table = input[0]
            std_table = self.table_mapping(table)

        if(2==len(input)):
            table,std_table = input
            std_table = std_table.strip().split(',')

        cn_name = self.meta_data.source_table_comments.get(table.upper(), "")
        if not cn_name:
            # read docs
            cn_name = self.source_toolkit.get_table_comment(table.upper())
            pass
        output['target_columns'] = self.fields_mapping(table,std_table)
        output['target_tables'] = std_table
        output['table_comment'] = cn_name
        output['table_name'] = table
        return {"output_data": output, "output": json.dumps(output, indent=4, ensure_ascii=False)}

    def table_mapping(self, table_name: str) -> List[str]:
        prompt = self.meta_data.table_mapping_question(table_name)['prompt']
        output = self.llm.invoke(StringPromptValue(text=self.table_prompt_prefix+prompt)).content
        return self.output_parser.parse(output,self.meta_data)

    def fields_mapping(self, table_name: str, std_table:List[str]) -> List[str]:
        if not self.meta_data.use_field_desc and len(std_table)>0:
            prompt = self.meta_data.fields_mapping_question(table_name,std_table)['prompt']
            output = self.llm.invoke(StringPromptValue(text=self.field_prompt_prefix+prompt)).content
            return self.output_parser.parseColumns(output,std_table,self.meta_data)
        else:
            colmus = []
            for std_tab in std_table:
                prompt = self.meta_data.fields_mapping_question(table_name,std_tab)['prompt']
                output = self.llm.invoke(StringPromptValue(text=prompt)).content
                cols = self.output_parser.parseColumns(output,std_table,self.meta_data)
                colmus+=cols
            return colmus




