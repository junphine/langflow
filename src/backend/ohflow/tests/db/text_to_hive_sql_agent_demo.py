from langchain_community.agent_toolkits import SQLDatabaseToolkit, create_sql_agent
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_community.llms import QianfanLLMEndpoint
from langchain.chains.sql_database.query import create_sql_query_chain
from ohflow.interface.agents.create_sql_agent import create_dremio_sql_agent
from langchain_community.utilities import SQLDatabase
import os

from ohflow.interface.db.ignite_database import IgniteDatabase
from ohflow.interface.agents.custom import CustomReActSingleInputOutputParser
from ohflow.interface.toolkits.sqltookits import DremioSQLDatabaseToolkit

configToken = '7ed238d0-601c-467a-a798-e4fe08ac0b39'
configServer="http://127.0.0.1:3000/api/v1/configuration/clusters/d959e415-035c-4d8a-b844-105cf24fc75d"

table_names_to_use = ["T_MDM_DRUG","T_MDM_PHARM","T_MDM_WM_DISEASE","T_MDM_PHYSICAL_EXAM","T_MDM_OPER","T_MDM_EXAM","T_MDM_PATIENT",'病案首页','住院收费结果']
table_names_to_use = None
ignore_tables = []

#db = SQLDatabase.from_uri("mysql+pymysql://root:123456@127.0.0.1/health_db")
#db = SQLDatabase.from_uri("ignite+pyodbc://@cq_std?configServer="+configServer+'&schema=PRE')
#db = IgniteDatabase.from_uri(f"ignite+pyodbc://@cq_std?metaServerURL={configServer}&metaAccessToken={configToken}",schema='PRE',
#                            sample_rows_in_table_info=0,include_tables=table_names_to_use)
#table_info = db.get_table_info(table_names_to_use)

db = IgniteDatabase.from_uri(f"ignite://127.0.0.1:10801/DWD?metaServerURL={configServer}&metaAccessToken={configToken}",
                             schema='DWD',
                             sample_rows_in_table_info=0,
                             include_tables=table_names_to_use,
                             ignore_tables=ignore_tables,
                             comment_as_identifier=True)

table_info = db.get_table_info_no_throw(table_names_to_use)


result = db.run("""SELECT "术前诊断代码","手术名称","手术级别","诊断名称"
FROM "病案首页手术信息" AS charges
JOIN "病案首页诊断信息" AS diseases ON charges."首页序号" = diseases."首页序号"
WHERE diseases."诊断代码" = 'HIV/AIDS'
""")

use_qianfan = not True

seed = '123'

model_kwargs = {}
if not use_qianfan:
    openai_api_base = "https://api.deepseek.com"
    #openai_api_base = "http://172.16.29.92:6060/v1"
    api_key = "sk-558a1f1b9957484eb52de0ddc2f9524a"
    model_name = 'deepseek-chat'
    #llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)
    llm = ChatOpenAI(
        max_tokens=2048,
        model_kwargs=model_kwargs,
        model=model_name,
        base_url=openai_api_base,
        api_key=api_key,
        temperature=0.4,
        seed=seed,
)
else:

    os.environ["QIANFAN_AK"] = "ghravljfesy0bSBsSzFsh0vr"
    os.environ["QIANFAN_SK"] = "0GGiysLIliu4p7WOYdm35C2hBB5jKLE2"
    llm = QianfanLLMEndpoint(temperature=0.9,model="Yi-34B-Chat")
    prompt = ChatPromptTemplate.from_messages(
        [
            ("user","你是谁，能简单介绍一下吗？")
        ]
    )
    chat = prompt | llm
    result = chat.invoke({})
    print(result)


output_parser = CustomReActSingleInputOutputParser()
toolkit = DremioSQLDatabaseToolkit(db=db, llm=llm)
agent_kwargs = {
    "handle_parsing_errors": True,
    "verbose": True,
    "allow_dangerous_code": True,
    "max_iterations": 15,
}
agent_description = None
agent = create_dremio_sql_agent(llm=llm, toolkit=toolkit, extra_tools=[],
                        prompt=None, prefix=agent_description, output_parser=output_parser, **agent_kwargs)

#response = agent.invoke({"input": "How many drugs are there?"})
#print('resp:'+str(response))
while True:
    text = input(">>\n")
    if text == '/quit':
        break
    try:
        if text.strip():
            response = agent.invoke({"input": text})
            print('resp:'+str(response))
    except Exception as e:
        print(e)




