"""SQLAlchemy wrapper around a database."""
from __future__ import annotations

import warnings
from typing import Any, Iterable, List, Optional, Sequence

import sqlalchemy
from sqlalchemy import MetaData, Table, create_engine, inspect, select, text
from sqlalchemy.engine import Engine
from sqlalchemy.exc import ProgrammingError, SQLAlchemyError
from sqlalchemy.schema import CreateTable
from langchain import sql_database
from ohflow.interface.db import *
from ohflow.interface.db.ignite_odbc_dialect import can_comment_identifier,comment_as_name


def _format_index(index: sqlalchemy.engine.interfaces.ReflectedIndex) -> str:
    return (
        f'Name: {index["name"]}, Unique: {index["unique"]},'
        f' Columns: {str(index["column_names"])}'
    )


def truncate_word(content: Any, *, length: int, suffix: str = "...") -> str:
    """
    Truncate a string to a certain number of words, based on the max string
    length.
    """

    if not isinstance(content, str) or length <= 0:
        return content

    if len(content) <= length:
        return content

    return content[: length - len(suffix)].rsplit(" ", 1)[0] + suffix


class IgniteDatabase(sql_database.SQLDatabase):
    """SQLAlchemy wrapper around ignite database."""

    def __init__(
        self,
        engine: Engine,
        schema: Optional[str] = None,
        metadata: Optional[MetaData] = None,
        ignore_tables: Optional[List[str]] = None,
        include_tables: Optional[List[str]] = None,
        sample_rows_in_table_info: int = 3,
        indexes_in_table_info: bool = False,
        custom_table_info: Optional[dict] = None,
        view_support: bool = False,
        max_string_length: int = 300,
        comment_as_identifier: bool = False,
    ):
        """Create engine from database URI."""
        self._engine = engine
        self._schema = schema
        self._comment_as_identifier = comment_as_identifier

        if isinstance(include_tables,str) and include_tables:
            include_tables = include_tables.replace(' ','').split(',')

        if isinstance(ignore_tables,str) and ignore_tables:
            ignore_tables = ignore_tables.replace(' ','').split(',')

        if include_tables and ignore_tables:
            raise ValueError("Cannot specify both include_tables and ignore_tables")

        if comment_as_identifier and sample_rows_in_table_info:
            raise ValueError("Cannot specify both comment_as_identifier and sample_rows_in_table_info")

        self._engine.dialect.driver = 'ignite'
        self._engine.dialect.comment_as_identifier = comment_as_identifier

        self._inspector = inspect(self._engine)

        # including view support by adding the views as well as tables to the all
        # tables list if view_support is True
        self._all_tables = set(
            self._inspector.get_table_names(schema=schema)
            + (self._inspector.get_view_names(schema=schema) if view_support else [])
        )

        self._include_tables = set(include_tables) if include_tables else set()
        if self._include_tables:
            missing_tables = self._include_tables - self._all_tables
            if missing_tables:
                raise ValueError(
                    f"include_tables {missing_tables} not found in database"
                )
        self._ignore_tables = set(ignore_tables) if ignore_tables else set()
        if self._ignore_tables:
            missing_tables = self._ignore_tables - self._all_tables
            if missing_tables:
                raise ValueError(
                    f"ignore_tables {missing_tables} not found in database"
                )
        usable_tables = self.get_table_names()
        self._usable_tables = set(usable_tables) if usable_tables else self._all_tables

        if not isinstance(sample_rows_in_table_info, int):
            raise TypeError("sample_rows_in_table_info must be an integer")

        self._sample_rows_in_table_info = sample_rows_in_table_info
        self._indexes_in_table_info = indexes_in_table_info

        self._custom_table_info = custom_table_info
        if self._custom_table_info:
            if not isinstance(self._custom_table_info, dict):
                raise TypeError(
                    "table_info must be a dictionary with table names as keys and the "
                    "desired table info as values"
                )
            # only keep the tables that are also present in the database
            intersection = set(self._custom_table_info).intersection(self._all_tables)
            self._custom_table_info = dict(
                (table, self._custom_table_info[table])
                for table in self._custom_table_info
                if table in intersection
            )

        self._max_string_length = max_string_length

        self._metadata = metadata or MetaData()
        # including view support if view_support = true
        self._metadata.reflect(
            views=view_support,
            bind=self._engine,
            only=list(self._usable_tables),
            schema=self._schema,
        )

    @classmethod
    def from_uri(
        cls, database_uri: str, engine_args: Optional[dict] = None, schema='public', **kwargs: Any
    ) -> IgniteDatabase:
        """Construct a Dremio flight engine from URI."""
        _engine_args = engine_args or {}
        return cls(create_engine(database_uri, **_engine_args), schema=schema, **kwargs)

    @classmethod
    def from_pyignite(
        cls,
        host: str,
        port: int = 10801,
        user: str = "ignite",
        password: str = "ignite",
        schema: str = "public",
        engine_args: dict = None,
        sample_rows_in_table_info: int = 0,
        include_tables: str = None,
        meta_server_url: str = None,
        meta_access_token: str = None,
        comment_as_identifier: bool = False,
    ) -> IgniteDatabase:
        """
        Construct a Dremio flight engine from parms.
        """
        uri = f"ignite+thin://{user}:{password}@{host}:{port}/{schema}"
        if meta_server_url and meta_access_token:
            uri += f"?metaServerURL={meta_server_url}&metaAccessToken={meta_access_token}"

        return cls.from_uri(
            database_uri=uri,
            engine_args=engine_args,
            schema=schema,
            view_support=True,
            sample_rows_in_table_info=int(sample_rows_in_table_info),
            include_tables = include_tables,
            comment_as_identifier = comment_as_identifier,
        )

    @property
    def dialect(self) -> str:
        """Return string representation of dialect to use."""
        #return self._engine.dialect.name
        return 'hive'

    def get_usable_table_names(self,quotes=True) -> Iterable[str]:
        """Get names of tables available."""
        if not self._comment_as_identifier:
            return self.get_table_names()
        tables = []
        for table in self._metadata.sorted_tables:
            if self._include_tables:
                if table.name not in self._include_tables:
                    continue
            elif self._ignore_tables:
                if table.name in self._ignore_tables:
                    continue

            name = comment_as_name(table)
            if quotes:
                tables.append('"'+name+'"')
            else:
                tables.append(name)
        return sorted(tables)


    def get_table_names(self) -> Iterable[str]:
        """Get names of tables available."""
        if self._include_tables:
            return sorted(self._include_tables)
        return sorted(self._all_tables - self._ignore_tables)

    @property
    def table_info(self) -> str:
        """Information about all tables in the database."""
        return self.get_table_info()

    def get_table_info(self, table_names: Optional[List[str]] = None) -> str:
        """Get information about specified tables.

        Follows best practices as specified in: Rajkumar et al, 2022
        (https://arxiv.org/abs/2204.00498)

        If `sample_rows_in_table_info`, the specified number of sample rows will be
        appended to each table description. This can increase performance as
        demonstrated in the paper.
        """
        all_table_names = self.get_usable_table_names(False)
        all_table_names = set(all_table_names)
        if table_names is not None:
            real_table_names = []
            for table_name in table_names:
                table_name = table_name.strip('"')
                exist_table =  table_name in all_table_names
                if not exist_table:
                    raise ValueError(f"table_names {table_name} not found in database")
                real_table_names.append(table_name)
            all_table_names = real_table_names

        meta_tables = [
            tbl
            for tbl in self._metadata.sorted_tables
            if tbl.name in all_table_names or tbl.comment in all_table_names
        ]

        tables = []
        tables.append('You can only use the following tables:')
        if self._sample_rows_in_table_info:
            tables.append('"'+'", "'.join(all_table_names).lower()+'"')
            tables.append('The table and columns definitions and sample data are below:')
        else:
            tables.append('"'+'", "'.join(all_table_names).lower()+'"')
            tables.append('The table and columns definitions are below:')

        for table in meta_tables:
            if self._custom_table_info and table.name in self._custom_table_info:
                tables.append(self._custom_table_info[table.name])
                continue

            sample_rows = ""
            if self._sample_rows_in_table_info:
                sample_rows = self._get_sample_rows(table)

            # add create table command
            create_table = str(CreateTable(table).compile(self._engine, compile_kwargs=dict(comment_as_identifier=self._comment_as_identifier)))
            table_info = f"{create_table.rstrip().lower()}"
            if table.comment:
                table_info += f"\ncomment '{table.comment}'\n"

            has_extra_info = (
                self._indexes_in_table_info or self._sample_rows_in_table_info
            )
            if has_extra_info:
                table_info += "\n\n/*"
            if self._indexes_in_table_info:
                table_info += f"\n{self._get_table_indexes(table)}\n"
            if self._sample_rows_in_table_info:
                table_info += f"\n{sample_rows}\n"
            if has_extra_info:
                table_info += "*/"
            tables.append(table_info)

        final_str = "\n\n".join(tables)
        return final_str

    def _get_table_indexes(self, table: Table) -> str:
        indexes = self._inspector.get_indexes(table.name)
        indexes_formatted = "\n".join(map(_format_index, indexes))
        return f"Table Indexes:\n{indexes_formatted}"

    def _get_sample_rows(self, table: Table) -> str:
        # build the select command
        command = select(table).limit(self._sample_rows_in_table_info)

        # save the columns in string format
        if self._comment_as_identifier:
            table_name = comment_as_name(table)
            columns_str = "\t|\t".join([comment_as_name(col) for col in table.columns])
        else:
            table_name = table.name
            columns_str = "\t|\t".join([col.name for col in table.columns])

        try:
            # get the sample rows
            with self._engine.connect() as connection:
                sample_rows_result = connection.execute(command)  # type: ignore
                # shorten values in the sample rows
                sample_rows = list(
                    map(lambda ls: [str(i)[:100] for i in ls], sample_rows_result)
                )

            # save the sample rows in string format
            if sample_rows:
                sample_rows_str = "\n".join(["|\t"+("\t|\t".join(row))+"\t|" for row in sample_rows])
            else:
                sample_rows_str = ''

        # in some dialects when there are no rows in the table a
        # 'ProgrammingError' is returned
        except ProgrammingError:
            sample_rows_str = ""

        return (
            f"{len(sample_rows)} rows from {table_name} table:\n"
            f"|\t{columns_str}\t|\n"
            f"{sample_rows_str}"
        )

    def _execute(self, command: str, fetch: Optional[str] = "all") -> Sequence:
        """
        Executes SQL command through underlying engine.

        If the statement returns no rows, an empty list is returned.
        """

        command0 = command
        if self._comment_as_identifier:
            command = self._engine.dialect.identifier_preparer.uncomment_identifiers(command)

        with self._engine.begin() as connection:
            if self._schema is not None:
                if self.dialect.startswith("dremio"):
                    connection.exec_driver_sql(f"USE {self._schema}")

            cursor = connection.execute(text(command))
            if cursor.returns_rows:
                if fetch == "all":
                    result = cursor.fetchall()
                elif fetch == "one":
                    result = cursor.fetchone()  # type: ignore
                else:
                    raise ValueError("Fetch parameter must be either 'one' or 'all'")
                return result
        return []

    def run(self, command: str, fetch: str = "all") -> str:
        """Execute a SQL command and return a string representing the results.

        If the statement returns rows, a string of the results is returned.
        If the statement returns no rows, an empty string is returned.
        """
        result = self._execute(command, fetch)
        # Convert columns values to string to avoid issues with sqlalchemy
        # truncating text
        if not result:
            return ""
        elif isinstance(result, list):
            res: Sequence = [
                tuple(truncate_word(c, length=self._max_string_length) for c in r)
                for r in result
            ]
        else:
            res = tuple(
                truncate_word(c, length=self._max_string_length) for c in result
            )
        return str(res)

    def get_table_info_no_throw(self, table_names: Optional[List[str]] = None) -> str:
        """Get information about specified tables.

        Follows best practices as specified in: Rajkumar et al, 2022
        (https://arxiv.org/abs/2204.00498)

        If `sample_rows_in_table_info`, the specified number of sample rows will be
        appended to each table description. This can increase performance as
        demonstrated in the paper.
        """
        try:
            return self.get_table_info(table_names)
        except ValueError as e:
            """Format the error message"""
            return f"Error: {e}"

    def run_no_throw(self, command: str, fetch: str = "all") -> str:
        """Execute a SQL command and return a string representing the results.

        If the statement returns rows, a string of the results is returned.
        If the statement returns no rows, an empty string is returned.

        If the statement throws an error, the error message is returned.
        """
        try:
            return self.run(command, fetch)
        except SQLAlchemyError as e:
            """Format the error message"""
            return f"Error: {e}"

