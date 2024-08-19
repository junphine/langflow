
from langchain_openai import ChatOpenAI
from langchain.chains.sql_database.query import create_sql_query_chain
from langchain_community.utilities import SQLDatabase


from sqlalchemy import create_engine, text
from ohflow.interface.db import *
from langchain_community.utilities import SQLDatabase

from ohflow.interface.db.ignite_database import IgniteDatabase

configToken = '7ed238d0-601c-467a-a798-e4fe08ac0b39'
configServer="http://127.0.0.1:3000/api/v1/configuration/clusters/d65ea122-56f4-4bbe-8598-0188121d494b"
table_names_to_use = ["TMDMDRUG","TMDMPHARM","TMDMWMDISEASE","TMDMPHYSICALEXAM","TMDMOPER","TMDMITEM","TMDMPATIENT"]

#db = SQLDatabase.from_uri("ignite+pyodbc://@cq_std?configServer="+configServer+'&schema=PRE')
db = IgniteDatabase.from_uri(f"ignite+pyodbc://@cq_std?configServer={configServer}&token={configToken}",schema='PRE',
                             sample_rows_in_table_info=0,include_tables=table_names_to_use)
table_info = db.get_table_info(table_names_to_use)

db = IgniteDatabase.from_uri(f"ignite://127.0.0.1:10801/PRE?configServer={configServer}&token={configToken}",schema='PRE',
                             sample_rows_in_table_info=0,include_tables=table_names_to_use)
table_info = db.get_table_info(table_names_to_use)
#llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)

openai_api_base = "https://api.deepseek.com"
seed = '123'
api_key = "sk-558a1f1b9957484eb52de0ddc2f9524a"
model_name = 'deepseek-chat'
model_kwargs = {}
llm = ChatOpenAI(
    max_tokens=2048,
    model_kwargs=model_kwargs,
    model=model_name,
    base_url=openai_api_base,
    api_key=api_key,
    temperature=0.4,
    seed=seed,
)

chain = create_sql_query_chain(llm, db, k=5)
response = chain.invoke({"question": "How many drugs are there?","table_names_to_use":table_names_to_use})
print('resp:'+response)
response = chain.invoke({"question": "药品“痤螨液”的包装方式是什么?","table_names_to_use":table_names_to_use})
print('resp:'+response)
response = chain.invoke({"question": "药品“痤螨液”的供应商是什么?","table_names_to_use":table_names_to_use})
print('resp:'+response)
response = chain.invoke({"question": "名称包含“糖尿病”的疾病有哪些?","table_names_to_use":table_names_to_use})
print('resp:'+response)

