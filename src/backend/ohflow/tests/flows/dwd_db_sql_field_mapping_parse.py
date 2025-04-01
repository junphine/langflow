import asyncio
import collections
import json,csv
import time
from asyncio import WindowsSelectorEventLoopPolicy

from langchain_core.prompt_values import StringPromptValue
from langchain_openai import ChatOpenAI

asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())
from langflow.load import run_flow_from_json
from pathlib import Path
from dotenv import load_dotenv
from ohflow.interface.agents.build_embedding_index import *
# 获取当前执行文件的绝对路径
current_file_path = Path(__file__).resolve()

# 获取当前执行文件的目录
current_directory = current_file_path.parent
PATH = r'C:/TEAM/湘潭项目仁医部分/'
PATH = r'C:\TEAM\青岛-七医新\\'
print("当前执行文件的目录:", current_directory)

load_dotenv('.env')

def remove_org_space(text):
    """
    使用正则表达式移除字符串中的${org_space}.部分。
    :param text: 输入字符串
    :return: 处理后的字符串
    """
    text = text.replace('`', '')
    # 定义正则表达式模式
    pattern = r'\$\{org_space\}\.'  # 匹配${org_space}.，注意转义$和{、}符号
    # 替换匹配的部分为空字符串
    result = re.sub(pattern, '', text)
    return result

def remove_table_dwd(text):
    """
    使用正则表达式移除字符串中的dwd.部分。
    :param text: 输入字符串
    :return: 处理后的字符串
    """
    # 定义正则表达式模式
    text = text.replace('`', '')
    pattern = r'DWD\.'  # 匹配${org_space}.，注意转义$和{、}符号
    # 替换匹配的部分为空字符串
    result = re.sub(pattern, '', text)
    return result

def remove_name_quose(text):
    """
    使用正则表达式移除字符串中的dwd.部分。
    :param text: 输入字符串
    :return: 处理后的字符串
    """
    # 定义正则表达式模式
    text = text.replace('`', '')
    pattern = r'\w\.'  #
    # 替换匹配的部分为空字符串
    result = re.sub(pattern, '', text)
    return result

def read_mapping_file(file_path):
    """
    读取映射文件并解析内容。
    :param file_path: 文件路径
    :return: 解析后的数据列表
    """
    data = []
    try:
        with open(file_path, mode='r', encoding='utf-8') as file:
            reader = file.readlines()
            # 跳过标题行
            for line in reader:
                # 去除每列的首尾空格
                row = line.strip().split('|')
                if len(row)==1:
                    continue
                row = [item.strip().strip('**') for item in row]
                if row[1] == '目标表名称' or row[1][0:2] == '--':
                    continue
                if row[3] == '常量' or row[3] == '-':
                    continue
                if len(row) == 6:
                    data.append({
                        "target_table": remove_table_dwd(row[1]),
                        "target_column": remove_name_quose(row[2]),
                        "source_table": remove_org_space(row[3]),
                        "source_column": remove_name_quose(row[4])
                    })
    except FileNotFoundError:
        print(f"文件未找到: {file_path}")
    except Exception as e:
        print(f"读取文件时发生错误: {e}")
    return data

# 示例使用
file_path = PATH+'sql_parsed_result.md'  # 替换为你的文件路径
result = read_mapping_file(file_path)
for item in result:
    print(item)

# 定义表头
fieldnames = 'target_table,target_column,source_table,source_column'.split(',')

# 写入 CSV 文件
with open(PATH+"sql_parsed_result.csv", "w", newline='', encoding="utf-8") as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)

    # 写入表头
    writer.writeheader()

    # 写入数据
    for row in result:
        writer.writerow(row)

print("CSV 文件已保存为 sql_parsed_result.csv")


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