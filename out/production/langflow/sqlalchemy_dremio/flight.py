
from sqlalchemy import schema, types, pool
from sqlalchemy.engine import default, reflection
from sqlalchemy.sql import compiler
from .base import *


class DremioDialect_flight(DremioDialect):

    name = 'dremio+flight'
    driver = "flight"
    supports_sane_rowcount = False
    supports_sane_multi_rowcount = False
    supports_statement_cache = True
    poolclass = pool.SingletonThreadPool
    statement_compiler = DremioCompiler
    paramstyle = 'pyformat'
    ddl_compiler = DremioDDLCompiler
    preparer = DremioIdentifierPreparer
    execution_ctx_cls = DremioExecutionContext

    def create_connect_args(self, url):
        opts = url.translate_connect_args(username='user')
        connect_args = {}
        connectors = ['HOST=%s' % opts['host'],
                      'PORT=%s' % opts['port']]

        if 'user' in opts:
            connectors.append('{0}={1}'.format('UID', opts['user']))
            connectors.append('{0}={1}'.format('PWD', opts['password']))

        if 'database' in opts:
            connectors.append('{0}={1}'.format('Schema', opts['database']))

        # Clone the query dictionary with lower-case keys.
        lc_query_dict = {k.lower(): v for k, v in url.query.items()}

        # metaServerUrl
        if 'metaserverurl' in lc_query_dict:
            self.meta_config_server = lc_query_dict['metaserverurl']
        # metaAccessToken
        if 'metaaccesstoken' in lc_query_dict:
            self.meta_access_token = lc_query_dict['metaaccesstoken']

        def add_property(lc_query_dict, property_name, connectors):
            if property_name.lower() in lc_query_dict:
                connectors.append('{0}={1}'.format(property_name, lc_query_dict[property_name.lower()]))
        
        add_property(lc_query_dict, 'UseEncryption', connectors)
        add_property(lc_query_dict, 'DisableCertificateVerification', connectors)
        add_property(lc_query_dict, 'TrustedCerts', connectors)
        add_property(lc_query_dict, 'routing_queue', connectors)
        add_property(lc_query_dict, 'routing_tag', connectors)
        add_property(lc_query_dict, 'quoting', connectors)
        add_property(lc_query_dict, 'routing_engine', connectors)
        add_property(lc_query_dict, 'Token', connectors)

        return [[";".join(connectors)], connect_args]

    @classmethod
    def import_dbapi(cls):
        import sqlalchemy_dremio.db as module
        return module

    def connect(self, *cargs, **cparams):
        return self.dbapi.connect(*cargs, **cparams)

    def last_inserted_ids(self):
        return self.context.last_inserted_ids

        