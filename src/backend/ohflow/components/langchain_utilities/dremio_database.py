from langchain_community.utilities.sql_database import SQLDatabase
from langflow.custom import CustomComponent
from ohflow.interface.db.dremio_database import DremioDatabase


class DremioDatabaseComponent(CustomComponent):
    name = "DremioDatabase"
    display_name = "Dremio Database"
    description = "SQL Database use Dremio"

    def build_config(self):
        return {
            "uri": {"display_name": "URI", "info": "URI to the dremio database."},
            "host": {"display_name": "Dremio Host", "info": "IP to the dremio database."},
            "port": {"display_name": "Dremio Port", "info": "Port to the dremio database."},
            "user": {"display_name": "Dremio User", "info": "User to the dremio database.","advanced": True,"required": False},
            "password": {"display_name": "Dremio Password", "info": "Password to the dremio database.","advanced": True,"required": False},
            "schema": {"display_name": "Dremio schema", "info": "schema to the dremio database."},
        }

    def clean_up_uri(self, uri: str) -> str:
        return uri.strip()

    def build(self,
        uri: str='',
        host: str=None,
        port: int=32010,
        user: str = "root",
        password: str = "",
        schema: str='public',
        **kwargs) -> SQLDatabase:
        if uri:
            uri = self.clean_up_uri(uri)
            return DremioDatabase.from_uri(uri)
        else:
            return DremioDatabase.from_flight(host,port=port,user=user,password=password,schema=schema)
