"""Toolkit for interacting with an SQL database."""

from typing import List

from langchain_core.output_parsers.transform import BaseTransformOutputParser
from langchain_core.language_models import BaseLanguageModel
from langchain_core.pydantic_v1 import Field
from langchain_core.tools import BaseToolkit

from langchain_community.tools import BaseTool
from langchain_community.tools.sql_database.tool import (
    InfoSQLDatabaseTool,
    ListSQLDatabaseTool,
    QuerySQLCheckerTool,
    QuerySQLDataBaseTool,
)
from langchain_community.utilities.sql_database import SQLDatabase


class DremioSQLDatabaseToolkit(BaseToolkit):
    """Toolkit for interacting with SQL databases.

    Parameters:
        db: SQLDatabase. The SQL database.
        llm: BaseLanguageModel. The language model.
    """

    db: SQLDatabase = Field(exclude=True)
    llm: BaseLanguageModel = Field(exclude=True)

    @property
    def dialect(self) -> str:
        """Return string representation of SQL dialect to use."""
        return self.db.dialect

    class Config:
        """Configuration for this pydantic object."""

        arbitrary_types_allowed = True

    def get_tools(self) -> List[BaseTool]:
        """Get the tools in the toolkit."""
        list_sql_database_tool = ListSQLDatabaseTool(db=self.db)
        sample = ' and sample rows' if self.db._sample_rows_in_table_info>0 else ""
        info_sql_database_tool_description = (
            "Input to this tool is a comma-separated list of tables, output is the "
            f"schema{sample} for those tables. "
            "Be sure that the tables actually exist by calling "
            f"{list_sql_database_tool.name} first! "
            "Example Input: table1, table2, table3"
        )
        info_sql_database_tool = InfoSQLDatabaseTool(
            db=self.db, description=info_sql_database_tool_description
        )
        query_sql_database_tool_description = (
            "Input to this tool is a detailed and correct SQL query, output is a "
            "result from the database. If the query is not correct, an error message "
            "will be returned. If an error is returned, rewrite the query, check the "
            "query, and try again. If you encounter an issue with Unknown column "
            f"'xxxx' in 'field list', use {info_sql_database_tool.name} "
            "to query the correct table fields."
        )
        query_sql_database_tool = QuerySQLDataBaseTool(
            db=self.db, description=query_sql_database_tool_description
        )
        query_sql_checker_tool_description = (
            "Use this tool to double check if your query is correct before executing "
            "it. Always use this tool before executing a query with "
            f"{query_sql_database_tool.name}!"
        )
        query_sql_checker_tool = QuerySQLCheckerTool(
            db=self.db, llm=self.llm, description=query_sql_checker_tool_description
        )
        query_sql_checker_tool.llm_chain.output_parser = SqlStrOutputParser()
        return [
            query_sql_database_tool,
            info_sql_database_tool,
            list_sql_database_tool,
            query_sql_checker_tool,
        ]

    def get_context(self) -> dict:
        """Return db context that you may want in agent prompt."""
        return self.db.get_context()


class SqlStrOutputParser(BaseTransformOutputParser[str]):
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

    def parse(self, text: str) -> str:
        """Returns the input text with no changes."""
        return text
