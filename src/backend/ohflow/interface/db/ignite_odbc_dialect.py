# dialects/mysql/pyodbc.py
# Copyright (C) 2005-2024 the SQLAlchemy authors and contributors
# <see AUTHORS file>
#
# This module is part of SQLAlchemy and is released under
# the MIT License: https://www.opensource.org/licenses/mit-license.php
# mypy: ignore-errors

import re
import requests
from sqlalchemy import schema, types, pool
from sqlalchemy.connectors.pyodbc import PyODBCConnector
from sqlalchemy.engine import default, reflection
from sqlalchemy.engine.reflection import ReflectionDefaults
from sqlalchemy.engine.interfaces import *
from sqlalchemy import create_engine, text
from sqlalchemy.sql import compiler
from sqlalchemy import exc,util
from sqlalchemy.engine import URL

_type_map = {
    'boolean': types.BOOLEAN,
    'bool': types.BOOLEAN,
    'varbinary': types.LargeBinary,
    'byte[]': types.LargeBinary,
    'date': types.DATE,
    'qdate': types.DATE,
    'float': types.FLOAT,
    'decimal': types.DECIMAL,
    'biginteger': types.DECIMAL,
    'bigdecimal': types.DECIMAL,
    'double': types.DOUBLE,
    'float': types.FLOAT,
    'interval': types.Interval,
    'int': types.INTEGER,
    'integer': types.INTEGER,
    'bigint': types.BIGINT,
    'long': types.BIGINT,
    'Long': types.BIGINT,
    'time': types.TIME,
    'uuid': types.UUID,
    'timestamp': types.TIMESTAMP,
    'timestamp with zone': types.TIMESTAMP,
    'varchar': types.VARCHAR,
    'json': types.VARCHAR,
    'smallint': types.SMALLINT,
    'short': types.SMALLINT,
    'byte': types.SMALLINT,
    'character varying': types.VARCHAR,
    'string': types.String,
    'object': types.String,
    'any': types.VARCHAR
}

def db_type(java_type:str):
    type = _type_map.get(java_type)
    if type is None:
        short_name = java_type.split('.')[-1].lower()
        type = _type_map.get(short_name)
    if type is None:
        print("unkown ignite field java type:"+java_type)
        return types.String
    return type

class IgniteExecutionContext(default.DefaultExecutionContext):
    pass


class IgniteCompiler(compiler.SQLCompiler):
    def visit_char_length_func(self, fn, **kw):
        return 'length{}'.format(self.function_argspec(fn, **kw))

    def visit_table(self, table, asfrom=False, **kwargs):

        if asfrom:
            if table.schema != None and table.schema != "":
                fixed_schema = ".".join(["\"" + i.replace('"', '') + "\"" for i in table.schema.split(".")])
                fixed_table = fixed_schema + ".\"" + table.name.replace("\"", "") + "\""
            else:
                fixed_table = "\"" + table.name.replace("\"", "") + "\""
            return fixed_table
        else:
            return ""

    def visit_tablesample(self, tablesample, asfrom=False, **kw):
        print(tablesample)

    def process(self, obj, **kwargs):
        kwargs.update({'literal_binds':True})
        return super().process(obj, **kwargs)


class IgniteDDLCompiler(compiler.DDLCompiler):
    def get_column_specification(self, column, **kwargs):
        colspec = self.preparer.format_column(column)
        colspec += " " + self.dialect.type_compiler.process(column.type)
        if column is column.table._autoincrement_column and \
                True and \
                (
                        column.default is None or \
                        isinstance(column.default, schema.Sequence)
                ):
            colspec += " IDENTITY"
            if isinstance(column.default, schema.Sequence) and \
                    column.default.start > 0:
                colspec += " " + str(column.default.start)
        else:
            default = self.get_column_default_string(column)
            if default is not None:
                colspec += " DEFAULT " + default

        if not column.nullable:
            colspec += " NOT NULL"

        if column.comment:
            colspec += f" comment '{column.comment}'"
        return colspec


class IgniteIdentifierPreparer(compiler.IdentifierPreparer):
    reserved_words = compiler.RESERVED_WORDS.copy()
    dremio_reserved = {'abs', 'all', 'allocate', 'allow', 'alter', 'and', 'any', 'are', 'array',
                       'array_max_cardinality', 'as', 'asensitivelo', 'asymmetric', 'at', 'atomic', 'authorization',
                       'avg', 'begin', 'begin_frame', 'begin_partition', 'between', 'bigint', 'binary', 'bit', 'blob',
                       'boolean', 'both', 'by', 'call', 'called', 'cardinality', 'cascaded', 'case', 'cast', 'ceil',
                       'ceiling', 'char', 'char_length', 'character', 'character_length', 'check', 'classifier',
                       'clob', 'close', 'coalesce', 'collate', 'collect', 'column', 'commit', 'condition', 'connect',
                       'constraint', 'contains', 'convert', 'corr', 'corresponding', 'count', 'covar_pop',
                       'covar_samp', 'create', 'cross', 'cube', 'cume_dist', 'current', 'current_catalog',
                       'current_date', 'current_default_transform_group', 'current_path', 'current_role',
                       'current_row', 'current_schema', 'current_time', 'current_timestamp',
                       'current_transform_group_for_type', 'current_user', 'cursor', 'cycle', 'date', 'day',
                       'deallocate', 'dec', 'decimal', 'declare', 'default', 'define', 'delete', 'dense_rank',
                       'deref', 'describe', 'deterministic', 'disallow', 'disconnect', 'distinct', 'double', 'drop',
                       'dynamic', 'each', 'element', 'else', 'empty', 'end', 'end-exec', 'end_frame', 'end_partition',
                       'equals', 'escape', 'every', 'except', 'exec', 'execute', 'exists', 'exp', 'explain', 'extend',
                       'external', 'extract', 'false', 'fetch', 'filter', 'first_value', 'float', 'floor', 'for',
                       'foreign', 'frame_row', 'free', 'from', 'full', 'function', 'fusion', 'get', 'global', 'grant',
                       'group', 'grouping', 'groups', 'having', 'hold', 'hour', 'identity', 'import', 'in',
                       'indicator', 'initial', 'inner', 'inout', 'insensitive', 'insert', 'int', 'integer',
                       'intersect', 'intersection', 'interval', 'into', 'is', 'join', 'lag', 'language', 'large',
                       'last_value', 'lateral', 'lead', 'leading', 'left', 'like', 'like_regex', 'limit', 'ln',
                       'local', 'localtime', 'localtimestamp', 'lower', 'match', 'matches', 'match_number',
                       'match_recognize', 'max', 'measures', 'member', 'merge', 'method', 'min', 'minute', 'mod',
                       'modifies', 'module', 'month', 'more', 'multiset', 'national', 'natural', 'nchar', 'nclob',
                       'new', 'next', 'no', 'none', 'normalize', 'not', 'nth_value', 'ntile', 'null', 'nullif',
                       'numeric', 'occurrences_regex', 'octet_length', 'of', 'offset', 'old', 'omit', 'on', 'one',
                       'only', 'open', 'or', 'order', 'out', 'outer', 'over', 'overlaps', 'overlay', 'parameter',
                       'partition', 'pattern', 'per', 'percent', 'percentile_cont', 'percentile_disc', 'percent_rank',
                       'period', 'permute', 'portion', 'position', 'position_regex', 'power', 'precedes', 'precision',
                       'prepare', 'prev', 'primary', 'procedure', 'range', 'rank', 'reads', 'real', 'recursive',
                       'ref', 'references', 'referencing', 'regr_avgx', 'regr_avgy', 'regr_count', 'regr_intercept',
                       'regr_r2', 'regr_slope', 'regr_sxx', 'regr_sxy', 'regr_syy', 'release', 'reset', 'result',
                       'return', 'returns', 'revoke', 'right', 'rollback', 'rollup', 'row', 'row_number', 'rows',
                       'running', 'savepoint', 'scope', 'scroll', 'search', 'second', 'seek', 'select', 'sensitive',
                       'session_user', 'set', 'minus', 'show', 'similar', 'skip', 'smallint', 'some', 'specific',
                       'specifictype', 'sql', 'sqlexception', 'sqlstate', 'sqlwarning', 'sqrt', 'start', 'static',
                       'stddev_pop', 'stddev_samp', 'stream', 'submultiset', 'subset', 'substring', 'substring_regex',
                       'succeeds', 'sum', 'symmetric', 'system', 'system_time', 'system_user', 'table', 'tablesample',
                       'then', 'time', 'timestamp', 'timezone_hour', 'timezone_minute', 'tinyint', 'to', 'trailing',
                       'translate', 'translate_regex', 'translation', 'treat', 'trigger', 'trim', 'trim_array',
                       'true', 'truncate', 'uescape', 'union', 'unique', 'unknown', 'unnest', 'update', 'upper',
                       'upsert', 'user', 'using', 'value', 'values', 'value_of', 'var_pop', 'var_samp', 'varbinary',
                       'varchar', 'varying', 'versioning', 'when', 'whenever', 'where', 'width_bucket', 'window',
                       'with', 'within', 'without', 'year'}

    dremio_unique = dremio_reserved - reserved_words
    reserved_words.update(list(dremio_unique))

    def __init__(self, dialect):
        super(IgniteIdentifierPreparer, self).__init__(dialect, initial_quote='"', final_quote='"')


class BaseIgniteDialect(default.DefaultDialect):
    name = 'ignite'
    supports_sane_rowcount = False
    supports_sane_multi_rowcount = False
    poolclass = pool.SingletonThreadPool
    statement_compiler = IgniteCompiler
    paramstyle = 'pyformat'
    ddl_compiler = IgniteDDLCompiler
    preparer = IgniteIdentifierPreparer
    execution_ctx_cls = IgniteExecutionContext
    cluster_config_server: str = None
    cluster_access_token: str = None
    models = None
    def last_inserted_ids(self):
        return self.context.last_inserted_ids

    def get_schema_info_from_config_server(self,table):
        if self.models is None:
            self.models = {}
            response = requests.get(self.cluster_config_server+"/models",headers=dict(Authorization='Token '+self.cluster_access_token))
            if response.status_code == 200:
                json_data = response.json()
                for model in json_data:
                    vType = model['valueType'].split('.')
                    self.models[vType[-1].upper()] = model
            else:
                print("Error:", response.status_code)
        if table in self.models:
            table_info = self.models[table]
            if 'fields' not in table_info:
                table_info['fields'] = {}
                domain_config_server = self.cluster_config_server[:self.cluster_config_server.find('/clusters/')]
                response = requests.get(domain_config_server+"/domains/"+table_info['id'],headers=dict(Authorization='Token '+self.cluster_access_token))
                if response.status_code == 200:
                    json_data = response.json()
                    for field in json_data['fields']:
                        table_info['fields'][field['name'].upper()] = field
            return table_info

        return None
    @reflection.cache
    def get_indexes(self, connection, table_name, schema=None, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        sql = "SELECT INDEX_NAME,INDEX_TYPE,COLUMNS,IS_PK,IS_UNIQUE FROM sys.indexes WHERE IS_PK=false AND TABLE_NAME='{0}' ".format(table_name)
        if schema != None and schema != "":
            sql += " AND SCHEMA_NAME = '{0}' ".format(schema)
        cursor = connection.execute(text(sql))
        indexes = []
        for spec in cursor:
            index_d = {}
            column_names = []
            cols = spec[2].split(',')
            for col in cols:
                col_name = col.split('"')[1]
                column_names.append(col_name)
            index_d["name"] = spec[0]
            index_d["column_names"] = column_names
            index_d["unique"] = spec[4]
            index_d["type"] = spec[1]

            indexes.append(index_d)
        indexes.sort(key=lambda d: d["name"] or "~")  # sort None as last
        cursor.close()
        return indexes if indexes else ReflectionDefaults.indexes()

    @reflection.cache
    def get_unique_constraints(
            self, connection, table_name, schema=None, **kw
    ):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        sql = "SELECT INDEX_NAME,INDEX_TYPE,COLUMNS,IS_PK,IS_UNIQUE FROM sys.indexes WHERE IS_PK=false AND IS_UNIQUE=true AND TABLE_NAME='{0}'".format(table_name)
        if schema != None and schema != "":
            sql += " AND SCHEMA_NAME = '{0}' ".format(schema)
        cursor = connection.execute(text(sql))
        indexes = []
        for spec in cursor:
            index_d = {}
            column_names = []
            if spec[2].find("\"ID\"")==0:
                continue
            cols = spec[2].split(',')
            for col in cols:
                col_name = col.split('"')[1]
                column_names.append(col_name)
            index_d["name"] = spec[0]
            index_d["column_names"] = column_names
            indexes.append(index_d)
        cursor.close()
        return indexes if indexes else ReflectionDefaults.unique_constraints()


    def get_pk_constraint(self, connection, table_name, schema=None, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        sql = "SELECT INDEX_NAME,INDEX_TYPE,COLUMNS,IS_PK,IS_UNIQUE FROM sys.indexes WHERE IS_PK=true OR IS_UNIQUE=true AND TABLE_NAME='{0}'".format(table_name)
        if schema != None and schema != "":
            sql += " AND SCHEMA_NAME = '{0}' ".format(schema)
        cursor = connection.execute(text(sql))
        index_d = {}
        for spec in cursor:
            if spec[2].find("\"_KEY\"")==0:
                continue
            cols = spec[2].split(',')
            column_names = []
            for col in cols:
                col_name = col.split('"')[1]
                column_names.append(col_name)
            index_d["name"] = spec[0]
            index_d["constrained_columns"] = column_names
            break
        cursor.close()
        return index_d if index_d else ReflectionDefaults.pk_constraint()

    def get_foreign_keys(self, connection, table_name, schema=None, **kw):
        return []

    @reflection.cache
    def get_columns(self, connection, table_name, schema, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        fields = {}
        if self.cluster_config_server:
            table_info = self.get_schema_info_from_config_server(table_name)
            if table_info is not None:
                fields = table_info['fields']
        pks = self.get_pk_constraint(connection,table_name,schema,**kw)
        sql = "SELECT COLUMN_NAME,TYPE,SCHEMA_NAME  FROM sys.TABLE_COLUMNS WHERE TABLE_NAME='{0}' ".format(table_name)
        if schema != None and schema != "":
            sql += " AND SCHEMA_NAME ='{0}' ".format(schema)
        cursor = connection.execute(text(sql))
        result = []
        for col in cursor:
            cname = col[0]
            if cname[0]=='_':
                continue
            ctype = db_type(col[1])
            comment = None
            if self.cluster_config_server:
                field = fields.get(cname)
                if field is not None:
                    comment = field.get('comment')
            is_pk = cname in pks["constrained_columns"]
            column = {
                "name": cname,
                "type": ctype,
                "default": None,
                "comment": comment,
                "nullable": True,
                "primary_key": is_pk,
            }
            result.append(column)
        cursor.close()
        return result

    @reflection.cache
    def get_table_names(self, connection, schema, **kw):
        sql = 'SELECT TABLE_NAME,TABLE_SCHEMA FROM INFORMATION_SCHEMA."TABLES"'
        if schema is not None and schema != "":
            sql += " WHERE TABLE_SCHEMA = '" + schema + "'"
        else:
            sql += " WHERE TABLE_SCHEMA NOT IN ('INFORMATION_SCHEMA','SYS')"
        result = connection.execute(text(sql))
        if schema == '':
            table_names = [r[1]+'.'+r[0] for r in result]
            return table_names
        else:
            table_names = [r[0] for r in result]
            return table_names

    @reflection.cache
    def get_table_comment(self, connection, table_name, schema=None, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        comment = None
        if self.cluster_config_server:
            table_info = self.get_schema_info_from_config_server(table_name)
            if table_info is not None:
                comment = table_info['tableComment']
        if comment is not None:
            return {"text": comment}
        else:
            return ReflectionDefaults.table_comment()

    @reflection.cache
    def get_table_options(self, connection, table_name, schema=None, **kw):
        return ReflectionDefaults.table_options()

    def get_schema_names(self, connection, schema=None, **kw):
        result = connection.execute(text("SHOW SCHEMAS"))
        schema_names = [r[0] for r in result]
        return schema_names


    @reflection.cache
    def has_table(self, connection, table_name, schema=None, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        sql = 'SELECT COUNT(*) FROM INFORMATION_SCHEMA."TABLES"'
        sql += " WHERE TABLE_NAME = '" + str(table_name) + "'"
        if schema is not None and schema != "":
            sql += " AND TABLE_SCHEMA = '" + str(schema) + "'"
        result = connection.execute(text(sql))
        countRows = [r[0] for r in result]
        return countRows[0] > 0

    def get_view_names(self, connection, schema=None, **kwargs):
        sql = 'SELECT NAME,SCHEMA FROM sys.views'
        if schema is not None and schema != "":
            sql += " WHERE SCHEMA = '" + schema + "'"
        else:
            sql += " WHERE SCHEMA NOT IN ('INFORMATION_SCHEMA','SYS')"
        result = connection.execute(text(sql))
        if schema == '':
            table_names = [r[1]+'.'+r[0] for r in result]
            return table_names
        else:
            table_names = [r[0] for r in result]
            return table_names

    def set_isolation_level(self, dbapi_connection, level):
        cursor = dbapi_connection.cursor()
        cursor.execute(f"SET SESSION TRANSACTION ISOLATION LEVEL {level}")
        cursor.close()

    def get_isolation_level(
            self, dbapi_connection: DBAPIConnection
    ) -> IsolationLevel:
        """Given a DBAPI connection, return its isolation level.

        When working with a :class:`_engine.Connection` object,
        the corresponding
        DBAPI connection may be procured using the
        :attr:`_engine.Connection.connection` accessor.

        Note that this is a dialect-level method which is used as part
        of the implementation of the :class:`_engine.Connection` and
        :class:`_engine.Engine` isolation level facilities;
        these APIs should be preferred for most typical use cases.


        .. seealso::

            :meth:`_engine.Connection.get_isolation_level`
            - view current level

            :attr:`_engine.Connection.default_isolation_level`
            - view default level

            :paramref:`.Connection.execution_options.isolation_level` -
            set per :class:`_engine.Connection` isolation level

            :paramref:`_sa.create_engine.isolation_level` -
            set per :class:`_engine.Engine` isolation level


        """
        raise NotImplementedError()


class IgniteExecutionContext_pyodbc(IgniteExecutionContext):
    pass

class IgniteDialect_pyodbc(PyODBCConnector, BaseIgniteDialect):
    name = "ignite+pyodbc"
    driver = "pyodbc"
    supports_statement_cache = True
    supports_unicode_statements = True
    pyodbc_driver_name = "Ignite"
    execution_ctx_cls = IgniteExecutionContext_pyodbc

    def create_connect_args(self, url:URL):
        opts = url.translate_connect_args(username="user")
        opts.update(url.query)

        if 'configServer' in opts:
            self.cluster_config_server = opts['configServer']
        if 'token' in opts:
            self.cluster_access_token = opts['token']

        return super().create_connect_args(url)

    def _detect_charset(self, connection):
        """Sniff out the character set in use for connection results."""

        # Prefer 'character_set_results' for the current connection over the
        # value in the driver.  SET NAMES or individual variable SETs will
        # change the charset without updating the driver's view of the world.
        #
        # If it's decided that issuing that sort of SQL leaves you SOL, then
        # this can prefer the driver value.

        # set this to None as _fetch_setting attempts to use it (None is OK)
        self._connection_charset = None
        return "utf-8"

    def _get_server_version_info(self, connection):
        return (2,16,999)

    def _extract_error_code(self, exception):
        m = re.compile(r"\((\d+)\)").search(str(exception.args))
        c = m.group(1)
        if c:
            return int(c)
        else:
            return None

    def on_connect(self):
        super_ = super().on_connect()

        def on_connect(conn):
            if super_ is not None:
                super_(conn)

            # declare Unicode encoding for pyodbc as per
            #   https://github.com/mkleehammer/pyodbc/wiki/Unicode
            pyodbc_SQL_CHAR = 1  # pyodbc.SQL_CHAR
            pyodbc_SQL_WCHAR = -8  # pyodbc.SQL_WCHAR
            conn.setdecoding(pyodbc_SQL_CHAR, encoding="utf-8")
            conn.setdecoding(pyodbc_SQL_WCHAR, encoding="utf-8")
            conn.setencoding(encoding="utf-8")
            conn.autocommit=True
        return on_connect


dialect = IgniteDialect_pyodbc
