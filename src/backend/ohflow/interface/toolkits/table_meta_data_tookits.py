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
from langchain_community.tools import BaseTool
from langchain_community.tools.sql_database.tool import BaseSQLDatabaseTool
from langchain_community.utilities.sql_database import SQLDatabase


class _InfoSQLDatabaseToolInput(BaseModel):
    table_names: str = Field(
        ...,
        description=(
            "A comma-separated list of the table names for which to return the schema. "
            "Example input: 'table1, table2, table3'"
        ),
    )


class InfoSQLDatabaseTool(BaseSQLDatabaseTool, BaseTool):  # type: ignore[override, override]
    """Tool for getting metadata about a SQL database."""

    name: str = "sql_db_schema"
    description: str = "Get the schema and sample rows for the specified SQL tables."
    args_schema: Type[BaseModel] = _InfoSQLDatabaseToolInput

    def _run(
            self,
            table_names: str,
            run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Get the schema for tables in a comma-separated list."""
        return self.db.get_table_info_no_throw(
            [t.strip() for t in table_names.split(",")]
        )


class _ListSQLDatabaseToolInput(BaseModel):
    tool_input: str = Field("", description="An empty string")


class ListSQLDatabaseTool(BaseSQLDatabaseTool, BaseTool):  # type: ignore[override, override]
    """Tool for getting tables names."""

    name: str = "sql_db_list_tables"
    description: str = "Input is an empty string, output is list of table names and its comment in the database."
    args_schema: Type[BaseModel] = _ListSQLDatabaseToolInput

    def _run(
            self,
            tool_input: str = "",
            run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Get a comma-separated list of table names."""
        return ", ".join(self.db.get_usable_table_names())


class DremioMetaDataToolkit(BaseToolkit):
    """Toolkit for interacting with remote SQL databases.

    Parameters:
        db: SQLDatabase. The SQL database.
        llm: BaseLanguageModel. The language model.
    """

    db: SQLDatabase = Field(exclude=True)

    meta_data_file: Optional[str] = Field(None, description="路径字段")

    @property
    def dialect(self) -> str:
        """Return string representation of SQL dialect to use."""
        return self.db.dialect

    class Config:
        """Configuration for this pydantic object."""

        arbitrary_types_allowed = True

    def resolve_path(self,path: str) -> str:
        """Resolves the path to an absolute path."""
        if not path:
            return path
        path_object = Path(path)

        if path_object.parts and path_object.parts[0] == "~":
            path_object = path_object.expanduser()
        elif path_object.is_relative_to("."):
            path_object = path_object.resolve()
        return str(path_object)

    def table_meta_data(self):
        if hasattr(self,'_table_meta_data'):
            return self._table_meta_data
        if self.meta_data_file is not None and self.meta_data_file:
            resolved_path = self.resolve_path(self.meta_data_file)
            extension = Path(resolved_path).suffix[1:].lower()

            if extension=='tsv':
                csv_args={
                    'delimiter': '\t',
                    'quotechar': '"'
                }
            else:
                csv_args={
                    'delimiter': ',',
                    'quotechar': '"'
                }

            result = {}
            with open(resolved_path, 'r',encoding='utf-8') as f:
                # Create a CSV reader object
                csv_reader = csv.DictReader(f,**csv_args)

                # Convert each row to a Data object

                for row in csv_reader:
                    table_name = row['TABLE_NAME'].upper()
                    if table_name not in result:
                        result[table_name] = dict(fields={})
                    tab_info = result[table_name]
                    if 'COLUMN_NAME' in row:
                        col_name = row['COLUMN_NAME'].upper()
                        tab_info['fields'][col_name] = row
                    else:
                        tab_info['info'] = row

            self._table_meta_data = result
            return result
        else:
            self._table_meta_data = {}
            return self._table_meta_data

    def get_table_comment(self,table:str) -> dict:
        tbl_info = self.table_meta_data().get(table.upper())
        if tbl_info and 'info' in tbl_info:
            return tbl_info.get('info',{}).get('TABLE_COMMENT')
        elif tbl_info and 'fields' in tbl_info:
            for field in tbl_info.get('fields',{}).values():
                return field.get('TABLE_COMMENT')
        else:
            return None

    def get_tools(self) -> List[BaseTool]:
        """Get the tools in the toolkit."""

        list_sql_database_tool = ListSQLDatabaseTool(db=self.db)

        info_sql_database_tool_description = (
            "Input to this tool is a comma-separated list of tables, output is the "
            "schema and sample rows for those tables. "
            "Be sure that the tables actually exist by calling "
            f"{list_sql_database_tool.name} first! "
            "Example Input: table1, table2, table3"
        )
        info_sql_database_tool = InfoSQLDatabaseTool(
            db=self.db, description=info_sql_database_tool_description
        )

        return [
            list_sql_database_tool,
            info_sql_database_tool,
        ]

    def get_context(self) -> dict:
        """Return db context that you may want in agent prompt."""
        return self.db.get_context()





