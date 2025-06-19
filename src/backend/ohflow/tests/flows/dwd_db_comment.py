
import collections
import json,csv
import time
import asyncio
from asyncio import WindowsSelectorEventLoopPolicy
asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())
from langchain_core.prompt_values import StringPromptValue
from langchain_openai import ChatOpenAI


from langflow.load import run_flow_from_json
from pathlib import Path
from dotenv import load_dotenv

# 获取当前执行文件的绝对路径
current_file_path = Path(__file__).resolve()

# 获取当前执行文件的目录
current_directory = current_file_path.parent
PATH = r'C:/TEAM/湘潭项目仁医部分/'
print("当前执行文件的目录:", current_directory)

load_dotenv('.env')


TWEAKS = {
    "DeepseekLLM-psNqL": {},
    "ChatInput-eJtsc": {},
    "TextInput-GmcDE": {},
    "Prompt-wztHN": {},
    "IgniteDatabase-CLhhm": {},
    "DremioSQLAgent-m6gQ1": {},
    "ChatOutput-TfiLo": {},
    "Prompt-4juhI": {},
    "TextOutput-ZDukc": {}
}

openai_api_base = "https://qianfan.baidubce.com/v2"
seed = '123'
api_key = "bce-v3/ALTAK-3aUXdbCrVZpKa4FdqRDyN/f740125eda8b3581c9b39015ecb916f8f5cf0c7a"
model_name = 'deepseek-v3'
model_kwargs = {}
llm = ChatOpenAI(
    max_tokens=2048,
    model_kwargs=model_kwargs,
    model=model_name,
    base_url=openai_api_base,
    api_key=api_key,
    temperature=0.8,
    seed=seed,
)



tables = {}
comment_dataset = {}
ods_tables = read_ods_tables(PATH+'ods-table-list.csv',use_cn_name=False)
ods_dataset = read_ods_dataset(PATH+'ods-columns-list.csv',use_cn_name=False)


def _ot(en):
    for table in ods_tables.values():
        if table['dataset_name_en']==en:
            return table['dataset_name_cn']
    else:
        return en

last_table_name = ''
table_str = ''
flag = 0
for row in ods_dataset.values():
    table_name = row['dataset_name_en']
    table_name_cn = _ot(table_name)
    field_name = row['data_name_en']
    field_name_cn = row['data_name_cn']
    if field_name_cn=='' and field_name.lower()!='id' and 'time' not in field_name.lower():
        flag +=1
    data_type = row['DATA_TYPE']
    table_str+=f'\t{field_name} {data_type} // {field_name_cn} \n'
    if last_table_name and table_name != last_table_name:
        table_str = f'表名称：{table_name} // {table_name_cn}\n 字段列表(字段名，类型，// 注释)：\n' + table_str
        if flag>=5 or table_name_cn=='':
            tables[table_name] = table_str
        table_str = ''
        flag = 0
    last_table_name = table_name


for table_name,table in tables.items():
    table = table.strip()
    if len(table)>100:
        prompt = f'下面是某医院HIS系统的某个数据表的字段列表，如果某行字段的注释为空，请你推测出其字段的中文注释，格式为： 字段名 类型 // 中文注释。最后再总结和推断出表的中文含义,格式为: 表名称：表名 // 表的中文注释。\n{table}\n 回答严格按照格式输出，不需要额外输出，开始推断'
        try:
            output = llm.invoke(StringPromptValue(text=prompt)).content
            comment_dataset[table_name] = output
        except Exception as e:
            print(e)
            time.sleep(10)
            comment_dataset[table_name] = ''
            continue


with open(PATH+'comment_result.json','w',encoding='utf-8') as fd:
    json.dump(comment_dataset,fd,indent=4,ensure_ascii=False)



result = run_flow_from_json(flow= current_directory / "_Database 中文注释.json",
                            input_value="开始",
                            user_id="b531f147-4c73-4913-bbd2-71abacdfe311",
                            session_id="b531f147", # provide a session id if you want to use session state
                            fallback_to_env_vars=True, # False by default
                            tweaks=TWEAKS)

print(result)