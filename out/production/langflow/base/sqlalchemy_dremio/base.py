from sqlalchemy import schema, types, pool, text
from sqlalchemy.engine import default, reflection
from sqlalchemy.engine.reflection import ReflectionDefaults
from sqlalchemy.sql import compiler
import re
import requests

_type_map = {
    'boolean': types.BOOLEAN,
    'BOOLEAN': types.BOOLEAN,
    'varbinary': types.LargeBinary,
    'VARBINARY': types.LargeBinary,
    'date': types.DATE,
    'DATE': types.DATE,
    'float': types.FLOAT,
    'FLOAT': types.FLOAT,
    'float32': types.FLOAT,
    'decimal': types.DECIMAL,
    'DECIMAL': types.DECIMAL,
    'double': types.DOUBLE,
    'DOUBLE': types.DOUBLE,
    'float64': types.DOUBLE,
    'interval': types.Interval,
    'INTERVAL': types.Interval,
    'int': types.INTEGER,
    'INT': types.INTEGER,
    'integer': types.INTEGER,
    'INTEGER': types.INTEGER,
    'bigint': types.BIGINT,
    'BIGINT': types.BIGINT,
    'time': types.TIME,
    'TIME': types.TIME,
    'timestamp': types.TIMESTAMP,
    'TIMESTAMP': types.TIMESTAMP,
    'varchar': types.VARCHAR,
    'VARCHAR': types.VARCHAR,
    'smallint': types.SMALLINT,
    'CHARACTER VARYING': types.VARCHAR,
    'ANY': types.VARCHAR,
    'object': types.VARCHAR,
    'dict': types.JSON,
    'ARRAY': types.ARRAY,
    'ROW': types.JSON,
    'BINARY VARYING': types.LargeBinary,
}


class DremioExecutionContext(default.DefaultExecutionContext):
    pass


class DremioCompiler(compiler.SQLCompiler):
    def visit_char_length_func(self, fn, **kw):
        return 'length{}'.format(self.function_argspec(fn, **kw))

    def visit_table(self, table, asfrom=False, **kwargs):

        if asfrom:
            if table.schema != None and table.schema != "":
                fixed_schema = ".".join(["\"" + i.replace('"', '') + "\"" for i in table.schema.split(".")])
                fixed_table = fixed_schema + ".\"" + table.name.replace("\"", "") + "\""
            else:
                # don't change anything. expect a fully and properly qualified path if no schema is passed.
                fixed_table = table.name
                # fixed_table = "\"" + table.name.replace("\"", "") + "\""
            return fixed_table
        else:
            return ""

    def visit_tablesample(self, tablesample, asfrom=False, **kw):
        print(tablesample)

    def process(self, obj, **kwargs):
        #return obj._compiler_dispatch(self, literal_binds=True, **kwargs)
        kwargs.update(literal_binds=True)
        return super().process(obj,**kwargs)


class DremioDDLCompiler(compiler.DDLCompiler):
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

        if column.comment and not hasattr(column, 'comment_as_name'):
            colspec += f" COMMENT '{column.comment}'"

        return colspec

    def create_table_suffix(self, table):
        if table.comment and not hasattr(table, 'comment_as_name'):
            return f"/* {table.comment} */"
        return ''


class DremioIdentifierPreparer(compiler.IdentifierPreparer):
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
        super(DremioIdentifierPreparer, self). \
            __init__(dialect, initial_quote='"', final_quote='"')

    def _requires_quotes(self, value: str) -> bool:
        """Return True if the given identifier requires quoting."""
        lc_value = value.lower()
        return (
            lc_value in self.reserved_words
            or value[0] in self.illegal_initial_characters
        )


class DremioDialect(default.DefaultDialect):
    name = 'dremio+pyodbc'
    driver = 'pyodbc'
    supports_sane_rowcount = False
    supports_sane_multi_rowcount = False
    supports_statement_cache = True
    poolclass = pool.SingletonThreadPool
    statement_compiler = DremioCompiler
    ddl_compiler = DremioDDLCompiler
    preparer = DremioIdentifierPreparer
    execution_ctx_cls = DremioExecutionContext
    default_paramstyle = "qmark"
    filter_schema_names = []

    meta_config_server: str = None
    meta_access_token: str = None
    models = {}

    @classmethod
    def dbapi(cls):
        import pyodbc as module
        return module

    def connect(self, *cargs, **cparams):
        engine_params = [param.lower() for param in cparams.keys()]
        if 'autocommit' not in engine_params:
            cparams['autocommit'] = 1
        # metaServerUrl
        if 'metaserverurl' in engine_params:
            self.meta_config_server = engine_params['metaserverurl']
        # metaAccessToken
        if 'metaaccesstoken' in engine_params:
            self.meta_access_token = engine_params['metaaccesstoken']

        return self.dbapi.connect(*cargs, **cparams)

    def last_inserted_ids(self):
        return self.context.last_inserted_ids

    def get_schema_info_from_config_server(self,table,schema):
        if table not in self.models:
            catelog = 'dremio'
            parts = schema.split('.',2)
            if len(parts)>1:
                catelog = parts[0]
                schema = parts[1]
            path = f'/{catelog}/{schema}/{table}'
            response = requests.get(self.meta_config_server+path,headers=dict(Authorization='Bearer '+self.meta_access_token))
            if response.status_code == 200:
                json_data = response.json()
                fields = {}
                for field in json_data['fields']:
                    fields[field['name']] = field
                json_data['fields'] = fields
                json_data['tableComment'] = ';'.join(filter(None,json_data['tags'])) if json_data['tags'] else None
                self.models[table] = json_data
            else:
                print("Error:", response.status_code)

        if table in self.models:
            table_info = self.models[table]
            return table_info

        return None

    def get_indexes(self, connection, table_name, schema, **kw):
        return []

    def get_pk_constraint(self, connection, table_name, schema=None, **kw):
        return []

    def get_foreign_keys(self, connection, table_name, schema=None, **kw):
        return []

    @reflection.cache
    def get_columns(self, connection, table_name, schema, **kw):
        fields = {}
        if self.meta_config_server:
            table_info = self.get_schema_info_from_config_server(table_name,schema)
            if table_info is not None:
                fields = table_info['fields']
        sql = "DESCRIBE \"{0}\"".format(table_name)
        if schema != None and schema != "":
            sql = "DESCRIBE \"{0}\".\"{1}\"".format(schema, table_name)
        cursor = connection.execute(text(sql))
        result = []
        for col in cursor:
            cname = col[0]
            ctype = _type_map[col[1]]
            comment = None
            if fields:
                field = fields.get(cname)
                if field is not None:
                    comment = field.get('comment')
            column = {
                "name": cname,
                "type": ctype,
                "default": None,
                "comment": comment,
                "nullable": True
            }
            result.append(column)
        return (result)

    @reflection.cache
    def get_table_names(self, connection, schema, **kw):
        sql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA."TABLES"'

        # Reverting #5 as Dremio does not support parameterized queries.
        if schema is not None:
            sql += " WHERE TABLE_SCHEMA = '" + schema + "'"

        result = connection.execute(text(sql))
        table_names = [r[0] for r in result]
        return table_names

    @reflection.cache
    def get_table_comment(self, connection, table_name, schema=None, **kw):
        if schema == '':
            parts = table_name.rsplit('.',2)
            if len(parts)==2:
                schema,table_name = parts
        comment = None
        if self.meta_config_server:
            table_info = self.get_schema_info_from_config_server(table_name,schema)
            if table_info is not None:
                comment = table_info['tableComment']
        if comment is not None:
            return {"text": comment}
        else:
            return ReflectionDefaults.table_comment()

    @reflection.cache
    def get_schema_names(self, connection, schema=None, **kw):
        if len(self.filter_schema_names) > 0:
            return self.filter_schema_names

        result = connection.execute(text("SHOW SCHEMAS"))
        schema_names = [r[0] for r in result]
        return schema_names

    @reflection.cache
    def has_table(self, connection, table_name, schema=None, **kw):
        sql = 'SELECT COUNT(*) FROM INFORMATION_SCHEMA."TABLES"'
        sql += " WHERE TABLE_NAME = '" + str(table_name) + "'"
        if schema is not None and schema != "":
            sql += " AND TABLE_SCHEMA = '" + str(schema) + "'"
        result = connection.execute(text(sql))
        countRows = [r[0] for r in result]
        return countRows[0] > 0

    @reflection.cache
    def get_view_names(self, connection, schema=None, **kwargs):
        sql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA."VIEWS"'

        # Reverting #5 as Dremio does not support parameterized queries.
        if schema is not None:
            sql += " WHERE TABLE_SCHEMA = '" + schema + "'"

        result = connection.execute(text(sql))
        table_names = [r[0] for r in result]
        return table_names

    # Workaround since Dremio does not support parameterized stmts
    # Old queries should not have used queries with parameters, since Dremio does not support it
    # and these queries failed. If there is no parameter, everything should work as before.
    def do_execute(self, cursor, statement, parameters, context):
        replaced_stmt = statement
        for v in parameters:
            escaped_str = str(v).replace("'", "''")
            if isinstance(v, (int, float)):
                replaced_stmt = replaced_stmt.replace('?', escaped_str, 1)
            else:
                replaced_stmt = replaced_stmt.replace('?', "'" + escaped_str + "'", 1)

        super(DremioDialect, self).do_execute_no_params(
            cursor, replaced_stmt, context
        )
