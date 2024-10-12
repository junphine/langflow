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
from sqlalchemy import create_engine, text


dialect=('postgresql','"')
dialect=('mysql','`')

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
    from sqlalchemy_dremio.flight import DremioDialect_flight

    db_uri = "dremio+flight://admin:qq123456@127.0.0.1:3201/public?UseEncryption=false"
    engine = create_engine(db_uri)
    tables = {}
    sql = 'SELECT 表名,表说明,表英文名 as name FROM "local"."全民健康"."全民健康平台数据采集接口规范V1.0.csv" '
    with engine.connect() as conn:
        result = conn.execute(text(sql))

        for row in result:
            table_name_cn = row[0]
            table_comment = row[1]
            table_name = row[2]
            if table_name_cn == '—般护理记录':
                table_name_cn = '一般护理记录'
            tables[table_name_cn] = {
                'table_comment': table_comment,
                'table_name_en': table_name,
                'table_name': table_name_cn,
                'fields': []
            }

    sql = 'SELECT 表名,字段名,字段描述,字段类型,长度,数据库字段名 as name,主键标识 FROM "local"."全民健康"."全民健康平台数据采集接口规范-字段V1.0.csv" order by 表名 '
    with engine.connect() as conn:
        result = conn.execute(text(sql))

        for row in result:
            table_name_cn:str = row[0]
            field_name_cn = row[1]
            field_comment = row[2]
            field_type = row[3]
            field_length = row[4]
            field_name = row[5]
            is_pk = row[6]
            if field_type=='VARCHAR2':
                field_length = field_length.replace(' ','')
                if int(field_length)<1024:
                    field_type = f'VARCHAR({field_length})'
                else:
                    field_type = f'TEXT'
            elif field_type=='NUMBER' or field_type=='NUMBEER':
                field_type = f'NUMERIC({field_length})'

            if table_name_cn.endswith('般护理记录'):
                table_name_cn = '一般护理记录'
            table_info = tables.get(table_name_cn)
            if table_info is None:
                continue
            table_info['fields'].append({
                'field_name_cn': field_name_cn,
                'field_comment': field_comment,
                'field_type': field_type,
                'field_length': field_length,
                'field_name': field_name,
                'is_pk': is_pk=='是'
            })

    lines = []
    for table_info in tables.values():
        table_name_cn = table_info['table_name']
        sql = f"create table \"{table_name_cn}\" (\n"
        pks = []
        first_line = True
        for field_info in table_info['fields']:
            not_null = ''
            if field_info['is_pk'] and not field_info['field_name_cn'].endswith('标志'):
                pks.append(f'"{field_info["field_name_cn"]}"')
                not_null = ' not null'
            if first_line:
                first_line = False
            else:
                sql += ','
            sql += f"\n\t\"{field_info['field_name_cn']}\" {field_info['field_type']}{not_null} comment '{field_info['field_comment']}'"
        if pks:
            sql += ",\n\tprimary key (" + ','.join(pks) + ')'
        sql += '\n);\n'
        if dialect[0]=='mysql':
            sql += f"alter table \"{table_name_cn}\" comment '{table_info['table_comment']}';\n\n"
        else:
            sql += f"comment on table \"{table_name_cn}\" is '{table_info['table_comment']}';\n\n"
        lines.append(sql)


    with open('dremio_gen_ddl.sql', 'w', encoding='utf-8') as f:
        f.writelines(lines)


if __name__ == "__main__":
    sqlalchemy_demo()


