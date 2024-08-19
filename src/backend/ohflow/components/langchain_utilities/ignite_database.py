from langchain_experimental.sql.base import SQLDatabase
from langflow.custom import CustomComponent
from ohflow.interface.db.ignite_database import IgniteDatabase


class IgniteDatabaseComponent(CustomComponent):
    name = "IgniteDatabase"
    display_name = "Ignite Database"
    description = "SQL Database use Ignite"

    def build_config(self):
        return {
            "uri": {"display_name": "URI", "info": "URI to the ignite database."},
            "host": {"display_name": "Ignite Host", "info": "IP to the ignite database."},
            "port": {"display_name": "Ignite Port", "info": "Port to the ignite database."},
            "user": {"display_name": "Ignite User", "info": "User to the ignite database.","required": False,"advanced": True},
            "password": {"display_name": "Ignite Password", "info": "Password to the ignite database.","required": False,"advanced": True},
            "schema": {"display_name": "Ignite schema", "info": "schema to the ignite database."},
            "sample_rows_in_table_info": {"display_name": "sample_rows_in_table_info", "info": "sample_rows_in_table_info default 3","required": False,"advanced": True},
            "include_tables": {"display_name": "include_tables", "info": "tables include to the ignite database.","required": False,"advanced": True},
            "config_server_url": {"display_name": "config_server_url", "info": "Cluster configServer URL to the ignite database.","required": False,"advanced": True},
            "config_access_token": {"display_name": "config_access_token", "info": "Cluster accessToken include to the ignite database.","required": False,"advanced": True},
        }

    def clean_up_uri(self, uri: str) -> str:
        return uri.strip()

    def build(self, uri: str='',
        host: str=None,
        port: int=10801,
        user: str = "ignite",
        password: str = "ignite",
        schema: str='public',
        sample_rows_in_table_info: int=0,
        include_tables: str=None,
        config_server_url: str=None,
        config_access_token: str=None,
        ) -> SQLDatabase:
        if uri:
            uri = self.clean_up_uri(uri)
            return IgniteDatabase.from_uri(f"{uri}?configServer={config_server_url}&token={config_access_token}",
                                           schema=schema,
                                           include_tables=include_tables,
                                           sample_rows_in_table_info=sample_rows_in_table_info)
        else:
            return IgniteDatabase.from_pyignite(host,port=port,user=user,password=password,
                                            schema=schema,
                                            include_tables=include_tables,
                                            sample_rows_in_table_info=sample_rows_in_table_info,
                                            config_server_url=config_server_url,
                                            config_access_token=config_access_token)
