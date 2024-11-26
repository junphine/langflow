
from langflow.load import run_flow_from_json
from pathlib import Path
from dotenv import load_dotenv
# 获取当前执行文件的绝对路径
current_file_path = Path(__file__).resolve()

# 获取当前执行文件的目录
current_directory = current_file_path.parent

print("当前执行文件的目录:", current_directory)

load_dotenv('.env')


TWEAKS = {
    "Prompt-7b2Ep": {
        "template": "You are an agent designed to interact with a SQL database.\nGiven an input question, create a syntactically correct {dialect} query to run, then look at the results of the query and return the answer.\nUnless the user specifies a specific number of examples they wish to obtain, always limit your query to at most 10 results.\nYou can order the results by a relevant column to return the most interesting examples in the database.\nNever query for all the columns from a specific table, only ask for the relevant columns given the question.\nYou have access to tools for interacting with the database.\nOnly use the below tools. Only use the information returned by the below tools to construct your final answer.\nYou MUST double check your query before executing it. If you get an error while executing a query, rewrite the query and try again.\n\nDO NOT make any DML statements (INSERT, UPDATE, DELETE, DROP etc.) to the database.\n\nIf the question does not seem related to the database, just return \"I don\\'t know\" as the answer.\n\n\nsql_db_query - Input to this tool is a detailed and correct SQL query, output is a result from the database. If the query is not correct, an error message will be returned. If an error is returned, rewrite the query, check the query, and try again. If you encounter an issue with Unknown column \\'xxxx\\' in \\'field list\\', use sql_db_schema to query the correct table fields.\nsql_db_schema - Input to this tool is a comma-separated list of tables, output is the schema and sample rows for those tables. Be sure that the tables actually exist by calling sql_db_list_tables first! Example Input: table1, table2, table3\nsql_db_list_tables - Input is an empty string, output is a comma-separated list of tables in the database.\nsql_db_query_checker - Use this tool to double check if your query is correct before executing it. Always use this tool before executing a query with sql_db_query!\n\nUse the following format:\n\nQuestion: the input question you must answer\nThought: you should always think about what to do\nAction: the action to take, should be one of [sql_db_query, sql_db_schema, sql_db_list_tables, sql_db_query_checker]\nAction Input: the input to the action\nObservation: the result of the action\n... (this Thought/Action/Action Input/Observation can repeat N times)\nThought: I now know the final answer\nFinal Answer: the final answer to the original input question\n\nBegin!\n\nQuestion:  {input}\nThought: I should look at the tables in the database to see what I can query.  Then I should query the schema of the most relevant tables.\n",
        "dialect": "h2",
        "input": ""
    },
    "SQLGenerator-EEBoI": {
        "input_value": "",
        "prompt": "",
        "top_k": 5
    },
    "DeepseekLLM-Vessh": {
        "input_value": "",
        "json_mode": False,
        "max_tokens": None,
        "model_kwargs": {},
        "model_name": "deepseek-chat",
        "openai_api_base": "",
        "openai_api_key": "DEEPSEEK_API_KEY",
        "output_schema": {},
        "seed": 1,
        "stream": False,
        "system_message": "",
        "temperature": 0.6
    },
    "ChatInput-Vb5x9": {
        "files": "",
        "background_color": "",
        "chat_icon": "",
        "input_value": "患者号为\"008\"的主治医生和所患疾病是什么？",
        "sender": "User",
        "sender_name": "User",
        "session_id": "",
        "should_store_message": True,
        "text_color": ""
    },
    "TextInput-r17CB": {
        "input_value": "以下是表名称和表注释，以及该表包含的字段名称、字段类型和字段注释\ncreate table TMdmPharm( // 药物 \n  id Integer primary key // 主键\n  sphmInx String // 药物SBR索引号\n  pharmName String // 药物名称\n  fundamentalFactorFlag String // 药物名称主因子标志\n  pharmNameEn String // 药物英文名称\n  pharmNameEnShort String // 药物英文名称简称\n  pharmOtherName String // 药物别名\n  pharmTrait String // 药物性状\n  pharmacologyDesc String // 药理及应用\n  drugUseMethod String // 药物用法描述\n  drugInteractionDesc String // 药物相互作用\n  attentionPoint String // 注意事项\n  drugFormCode String // 药物剂型代码\n  drugFormName String // 药物剂型名称\n  drugSpec String // 药物规格\n  versionDesc String // 版本信息\n  note String // 备注\n  dataValidityFlag String // 数据有效标志\n  dataCreateTime Timestamp // 数据创建时间\n  dataModifyTime Timestamp // 数据修改时间\n  chemicalFormulaUrl String // 药物化学式\n)"
    },
    "ChatOutput-lwU8m": {
        "background_color": "",
        "chat_icon": "",
        "data_template": "{text}",
        "input_value": "",
        "sender": "Machine",
        "sender_name": "AI",
        "session_id": "",
        "should_store_message": True,
        "text_color": ""
    },
    "IgniteDatabase-awZAo": {
        "comment_as_identifier": False,
        "host": "127.0.0.1",
        "include_tables": "",
        "meta_access_token": "7ed238d0-601c-467a-a798-e4fe08ac0b39",
        "meta_server_url": "http://127.0.0.1:3000/api/v1/configuration/clusters/d65ea122-56f4-4bbe-8598-0188121d494b",
        "password": "ignite",
        "port": 10801,
        "sample_rows_in_table_info": 0,
        "schema": "PUBLIC",
        "uri": "",
        "user": "ignite"
    },
    "StoreMessage-BTNey": {
        "message": "",
        "sender": "",
        "sender_name": "",
        "session_id": ""
    },
    "RedisChatMemory-jdNjn": {
        "database": "0",
        "host": "localhost",
        "key_prefix": "",
        "password": "",
        "port": 11212,
        "session_id": "",
        "username": ""
    },
    "TextOutput-ikGYp": {
        "input_value": ""
    }
}

result = run_flow_from_json(flow=current_directory / "_Database全民健康数据智能检索 .json",
                            input_value="患者号为\"008\"的主治医生和所患疾病是什么？",
                            user_id="b531f147-4c73-4913-bbd2-71abacdfe311",
                            session_id="", # provide a session id if you want to use session state
                            fallback_to_env_vars=True, # False by default
                            tweaks=TWEAKS)

print(result)
