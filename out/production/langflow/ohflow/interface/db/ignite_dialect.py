from .ignite_odbc_dialect import *

def to_python_identifier(input_str):
    # 使用正则表达式将CamelCase转换为下划线分隔
    s1 = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', input_str).lower()
    # 如果字符串以数字开头，则添加一个下划线前缀
    if s1[0].isdigit():
        s1 = '_' + s1
    return s1

class IgniteExecutionContext_pyignite(IgniteExecutionContext):
    pass

class IgniteDialect_pyignite(BaseIgniteDialect):
    name = "ignite"
    driver = "thin connector"
    supports_statement_cache = True
    supports_unicode_statements = True
    execution_ctx_cls = IgniteExecutionContext_pyignite

    def create_connect_args(self, url:URL):
        opts = url.translate_connect_args(username='user')
        connect_args = {}
        # Clone the query dictionary with lower-case keys.
        lc_query_dict = {k.lower(): v for k, v in url.query.items()}

        connectors = ['HOST=%s' % opts['host'],
                      'PORT=%s' % opts['port']]

        if 'user' in opts:
            connectors.append('{0}={1}'.format('UID', opts['user']))
            connectors.append('{0}={1}'.format('PWD', opts['password']))

        if 'token' in opts:
            connectors.append('{0}={1}'.format('Token', opts['token']))

        if 'database' in opts:
            connectors.append('{0}={1}'.format('Schema', opts['database']))
            lc_query_dict['schema'] = opts['database']

        if 'configServer' in opts:
            self.cluster_config_server = opts['configServer']

        def add_property(lc_query_dict, property_name, type):
            if property_name.lower() in lc_query_dict:
                var_name = to_python_identifier(property_name)
                connect_args[var_name] = type(lc_query_dict[property_name.lower()])


        add_property(lc_query_dict, 'schema',str)
        add_property(lc_query_dict, 'distributedJoins',bool)
        add_property(lc_query_dict, 'local',bool)
        add_property(lc_query_dict, 'enforceJoinOrder',bool)
        add_property(lc_query_dict, 'collocated', bool)
        add_property(lc_query_dict, 'max_rows', int)
        add_property(lc_query_dict, 'timeout', int)

        return [[";".join(connectors)], connect_args]

    @classmethod
    def import_dbapi(cls):
        from . import ignite_dbapi
        return ignite_dbapi

    def connect(self, *cargs, **cparams):
        return self.dbapi.connect(*cargs, **cparams)

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
            conn.autocommit=False
        return on_connect


dialect = IgniteDialect_pyignite