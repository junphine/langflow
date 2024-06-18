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

def odbc_demo():
    import pyodbc
    cnxn  = pyodbc.connect("DSN=dremio")
    cursor = cnxn.cursor()
    for row in cursor.tables():
        print(row.table_name)


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
    from sqlalchemy import create_engine
    from sqlalchemy_dremio.flight import DremioDialect_flight

    db_uri = "dremio+flight://root:123456@172.16.29.85:3201/dremio?UseEncryption=false"
    engine = create_engine(db_uri)
    sql = 'SELECT * FROM sys.options limit 5 -- SQL Alchemy Flight Test '

    result = engine.execute(sql)

    for row in result:
        print(row[0])

if __name__ == "__main__":
    sqlalchemy_demo()
    odbc_demo()

