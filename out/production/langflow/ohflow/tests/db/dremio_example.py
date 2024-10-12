"""
  Copyright (C) 2017-2021 Dremio Corporation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
"""
from dremio.arguments.parse import parse_arguments
from dremio.flight.endpoint import DremioFlightEndpoint
import time

from ohflow.interface.db.dremio_database import DremioDatabase

metaAccessToken  = '62it7dgc68cpfesiqs5ag8gk0a'
metaConfigServer = "http://127.0.0.1:9047/apiv2/datasets/summary-x"

def odbc_demo():
    from sqlalchemy_dremio.base import DremioDialect
    import pyodbc
    db_uri = f"DSN=dremio;metaServerURL={metaConfigServer};metaAccessToken={metaAccessToken}"
    db_uri = f"DSN=dremio;"
    cnxn  = pyodbc.connect(db_uri)
    cursor = cnxn.cursor()
    for row in cursor.tables():
        print(row.table_name)

    db = DremioDatabase.from_uri(db_uri,schema='ignite.DWD',sample_rows_in_table_info=1)
    table_info = db.get_table_info()
    print(table_info)


def flight_demo():
    # Parse the command line arguments.
    args = parse_arguments()

    # Instantiate DremioFlightEndpoint object
    dremio_flight_endpoint = DremioFlightEndpoint(args)

    # Connect to Dremio Arrow Flight server endpoint.
    flight_client = dremio_flight_endpoint.connect()

    # Execute query
    dataframe = dremio_flight_endpoint.execute_query(flight_client)

    # Print out the data
    print(dataframe)

def sqlalchemy_demo():
    from sqlalchemy import create_engine,text
    from sqlalchemy_dremio.flight import DremioDialect_flight

    db_uri = "dremio+flight://root:123456@172.16.29.85:3201/dremio?UseEncryption=false"
    engine = create_engine(db_uri)
    sql = 'SELECT * FROM sys.options limit 5 -- SQL Alchemy Flight Test '
    with engine.connect() as conn:
        result = conn.execute(text(sql))
        for row in result:
            print(row[0])

def sqlalchemy_meta_demo():
    from sqlalchemy import create_engine,text
    from sqlalchemy_dremio.flight import DremioDialect_flight
    db_uri = f"dremio+flight://root:123456@172.16.29.85:3201/public?metaServerURL={metaConfigServer}&metaAccessToken={metaAccessToken}&UseEncryption=false"
    db_uri = f"dremio+flight://admin:qq123456@127.0.0.1:3201/public?metaServerURL={metaConfigServer}&metaAccessToken={metaAccessToken}&UseEncryption=false"


    db = DremioDatabase.from_uri(db_uri,schema='ignite.DWD',sample_rows_in_table_info=1)
    table_info = db.get_table_info()

    engine = create_engine(db_uri)
    sql = 'SELECT * FROM sys.options limit 5 -- SQL Alchemy Flight Test '
    with engine.connect() as conn:
        result = conn.execute(text(sql))
        for row in result:
            print(row[0])

if __name__ == "__main__":
    #sqlalchemy_meta_demo()
    odbc_demo()

