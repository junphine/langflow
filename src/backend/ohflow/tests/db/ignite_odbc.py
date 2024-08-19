import pyodbc
conn = pyodbc.connect('Driver={Apache Ignite};Address=127.0.0.1:10801;Schema=PRE')
conn.setencoding(encoding='utf-8')
conn.setdecoding(sqltype=pyodbc.SQL_CHAR, encoding="utf-8")
conn.setdecoding(sqltype=pyodbc.SQL_WCHAR, encoding="utf-8")
conn.autocommit=False
cursor = conn.cursor()

result = cursor.execute('SELECT * FROM TMdmCompany  limit 100')
for item in result:
    print(item)

cursor.close()
conn.commit()
conn.close()

configServer="http://127.0.0.1:3000/api/v1/configuration/clusters/e96da6a2-3615-4883-9c31-9df7c9ea2ae7"
from sqlalchemy import create_engine, text
from ohflow.interface.db import *
from langchain_community.utilities import SQLDatabase

db = SQLDatabase.from_uri("ignite+pyodbc://@cq_std?configServer="+configServer+'&schema=PRE')
tables = db.get_table_names()
result = db.run(text("SELECT * FROM TMdmCompany limit 100"))

engine = create_engine("ignite+pyodbc://@cq_std?configServer="+configServer+'&schema=PRE')
with engine.connect() as conn:
    result = conn.execute(text("SELECT * FROM TMdmCompany  limit 100"))
    one = result.fetchone()
    two = result.fetchmany(2)
    all = result.fetchall()
    for i in result:
        print(i)



engine = create_engine("ignite+thin://127.0.0.1:10801/PRE?configServer="+configServer+'&max_rows=100')
with engine.connect() as conn:
    result = conn.execute(text("SELECT * FROM TMdmCompany  limit 100"))
    fields = result.keys()
    one = result.fetchone()
    two = result.fetchmany(2)
    all = result.fetchall()
    for i in result:
        print(i)

print('OK')
