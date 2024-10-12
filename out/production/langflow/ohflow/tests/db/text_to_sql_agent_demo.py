from langchain_community.agent_toolkits import SQLDatabaseToolkit, create_sql_agent
from langchain_openai import ChatOpenAI
from langchain.chains.sql_database.query import create_sql_query_chain
from langchain_community.utilities import SQLDatabase


from ohflow.interface.db.ignite_database import IgniteDatabase
from ohflow.interface.agents.custom import CustomReActSingleInputOutputParser

configToken = '7ed238d0-601c-467a-a798-e4fe08ac0b39'
configServer="http://127.0.0.1:3000/api/v1/configuration/clusters/c34b9cb5-e7e0-4f81-97a7-9589f0c2b623"
table_names_to_use = ["T_MDM_DRUG","T_MDM_PHARM","T_MDM_WM_DISEASE","T_MDM_PHYSICAL_EXAM","T_MDM_OPER","T_MDM_EXAM","T_MDM_PATIENT",'病案首页','住院收费结果']
table_names_to_use = None
#db = SQLDatabase.from_uri("mysql+pymysql://root:123456@127.0.0.1/health_db")
#db = SQLDatabase.from_uri("ignite+pyodbc://@cq_std?configServer="+configServer+'&schema=PRE')
#db = IgniteDatabase.from_uri(f"ignite+pyodbc://@cq_std?metaServerURL={configServer}&metaAccessToken={configToken}",schema='PRE',
#                            sample_rows_in_table_info=0,include_tables=table_names_to_use)
#table_info = db.get_table_info(table_names_to_use)

db = IgniteDatabase.from_uri(f"ignite://127.0.0.1:10802/PUBLIC?metaServerURL={configServer}&metaAccessToken={configToken}",schema='PUBLIC',
                             sample_rows_in_table_info=0,include_tables=table_names_to_use)
table_info = db.get_table_info_no_throw(table_names_to_use)
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
output_parser = CustomReActSingleInputOutputParser()
toolkit = SQLDatabaseToolkit(db=db, llm=llm)
agent_kwargs = {
    "handle_parsing_errors": True,
    "verbose": True,
    "allow_dangerous_code": True,
    "max_iterations": 15,
}
agent_description = None
agent = create_sql_agent(llm=llm, toolkit=toolkit, extra_tools=[],
                        prompt=None, prefix=agent_description, output_parser=output_parser, **agent_kwargs)

#response = agent.invoke({"input": "How many drugs are there?"})
#print('resp:'+str(response))
while True:
    text = input(">>\n")
    if text == '/quit':
        break
    try:
        response = agent.invoke({"input": text})
        print('resp:'+str(response))
    except Exception as e:
        print(e)


"""
response = agent.invoke({"input": "我要在病案首页查肺癌诊断名称包含  (肺|气管).*(恶性肿瘤|癌) or 诊断代码包含 C34的病人信息"})
print('resp:'+str(response))
response = agent.invoke({"input": "名称包含“糖尿病”的疾病有哪些?"})
print('resp:'+str(response))
"""


