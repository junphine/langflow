import json
import re
import random
import re
import collections

from ohflow.interface.agents.build_embedding_index import *

PATH = r'C:/TEAM/湘潭项目仁医部分/'
# 字段是否使用注释
use_field_desc=not True
dataset_mapping_prompt = {}
std_tables = read_std_tables(PATH+'湘潭数据模型-目录.csv')
std_dataset = read_std_dataset(PATH+'湘潭数据模型.csv')
for id,row in std_dataset.items():
    field_name = standaze_field_name(row['data_name_cn'])
    std_table = std_tables[row['dataset_name_cn']]
    fields = std_table.get('fields', {})
    if len(fields)==0:
        std_table['fields'] = fields
    fields[field_name] = row

# 构建提示词模板： tables

table_mapping_prompt = f'\n标准库中定义了如下表：\n'
table_mapping_prompt += f'| 表英文名 | 表中文名 | 表注释 |\n'
for table_name,table in std_tables.items():
    table_name_en = table['dataset_name_en']
    table_name_cn = table['dataset_name_cn']
    table_desc = table['dataset_desc']
    table_mapping_prompt += f'| {table_name_en} | {table_name_cn} '
    if table_desc:
        table_mapping_prompt += f' | {table_desc} '
    table_mapping_prompt += '|\n'

    fields = table.get('fields', {})
    prompt = f'标准库中表"{table_name}"的表字段信息如下：\n'
    prompt += f'| 字段英文名 | 字段中文名 | 字段注释 |\n'
    i = 1
    for fname,field in fields.items():
        data_desc= field["data_definition"]
        prompt += f'| {field["data_name_en"]} | {field["data_name_cn"]} '
        if use_field_desc and data_desc:
            prompt += f' | {data_desc} '
        prompt += '|\n'
        i += 1
    dataset_mapping_prompt[table_name] = prompt

std_keys = list(std_dataset.keys())

ods_tables = {}
ods_dataset = {}
"""
ods_tables = read_ods_tables(PATH+'贵州省医药监管平台模型描述.csv')
ods_dataset = read_ods_dataset(PATH+'贵州省医药监管平台ODS模型.csv')

for row in ods_dataset.values():
    table_name = row['dataset_name_cn']
    field_name = row['data_name_cn']
    fields = ods_tables[table_name].get('fields', {})
    if len(fields)==0:
        ods_tables[table_name]['fields'] = fields
    fields[field_name] = row
"""


max_len = 0

# 返回询问ods_table的提示词
def table_mapping_question(ods_table:str):
    input_str = ods_table
    if isinstance(ods_table,str):
        ods_table = ods_tables.get(ods_table)
    if ods_table is not None:
        name = ods_table['dataset_name_cn']
        input_str = f'(表英文名:{ods_table["dataset_name_en"]},表中文名:{name},表注释：{ods_table["dataset_desc"]})'
    prompt = table_mapping_prompt+ f'从标准库中选出与用户输入的表"{input_str}"能对应的表，只需返回表中文名\n'
    return dict(prompt=prompt)

def field_mapping_question(ods_table:str,ods_field:str,std_table:str|list):
    input_table = ods_table
    if isinstance(ods_table,str):
        ods_table = ods_tables.get(ods_table)
    if ods_table is not None:
        name = ods_table['dataset_name_cn']
        input_table = name

    input_str = ods_field
    if isinstance(ods_field,str):
        id = input_table+'.'+ods_field
        ods_field = ods_dataset.get(id)
    if ods_field is not None:
        name = ods_field['data_name_cn']
        desc = ods_field["data_definition"]
        if desc:
            desc = '注释：'+ desc
        input_str = f'(英文名:{ods_field["data_name_en"]},中文名:{name}, {desc})'
    prompt_prefix = ''
    if isinstance(std_table,str):
        prompt_prefix = dataset_mapping_prompt[std_table]
    else:
        for tab in std_table:
            prompt_prefix += dataset_mapping_prompt[tab]
            prompt_prefix += "\n"
    prompt = prompt_prefix+ f'从所给标准库的表中选出与业务表"{input_table}"的字段"{input_str}"可以映射对应的字段，只需返回字段中文名，允许多选，若无匹配字段，则返回无。\n'
    return dict(prompt=prompt)


#所有匹配的字段： std+ods:1
matched_dict = {} # std_table.field+ods_table.field:1
matched_table_dict = {} # std_table+ods_table:1
matched_field_dict = {} # std_field+ods_field:1
#计算召回率，ods字段在标准库表找到结果则为字段名
matched_ods_field_table_dict = {} # ods_table.field+std_table:1
dataset = []
fields_dataset = []
c = 0
with open(PATH+'gov_column_mapping.csv','r',encoding='utf-8') as fd:
    reader = csv.DictReader(fd)
    for row in reader:
        row['target_column'] = remove_number_around(row['target_column'])
        label = row['source_table']+'.'+row['source_column'] # ods
        if row['target_table'].startswith('v_'):
            row['target_table'] = row['target_table'][2:]
        dwd_links = row['target_table'] +'.'+row['target_column'] # std
        dwd_links = dwd_links.split('\n')
        std_labels = []
        for dwd_link in dwd_links:
            dwd_link = remove_brackets(dwd_link).strip(';').strip()
            if dwd_link in std_dataset:
                #std_labels.append(dwd_link)
                c+=1
            else:
                print("not found std table.column "+dwd_link)

        for dwd_link in std_labels:
            dwd_link = standaze_field_name(dwd_link)
            if dwd_link in std_dataset:
                row_std = std_dataset[dwd_link]
                table_match_id = row_std['dataset_name_cn']+':'+row['dataset_name_cn']
                if table_match_id in matched_table_dict:
                    matched_table_dict[table_match_id]+=1
                else:
                    matched_table_dict[table_match_id]=1
                    if len(std_labels)>0:
                        ods_table = ods_tables[row['dataset_name_cn']]
                        data = table_mapping_question(ods_table)
                        data["anser"] = row_std['dataset_name_cn']

                        dataset.append(data)
                std_field_name = standaze_field_name(row_std['data_name_cn'])
                field_match_id = std_field_name+':'+row['data_name_cn']
                if field_match_id in matched_field_dict:
                    matched_field_dict[field_match_id]+=1
                else:
                    matched_field_dict[field_match_id]=1

                if dwd_link+':'+label in matched_dict:
                    matched_dict[dwd_link+':'+label]+=1
                else:
                    matched_dict[dwd_link+':'+label]=1
                    #正例多生成几份
                    ods_table = ods_tables[row['dataset_name_cn']]
                    data = field_mapping_question(ods_table,row,row_std['dataset_name_cn'])
                    data["anser"] = std_field_name

                    fields_dataset.append(data)

                field_match_id = std_field_name+':'+row['data_name_cn']
                matched_ods_field_table_dict[label+':'+row_std['dataset_name_cn']] = std_field_name

            else:
                print(dwd_link)
                continue


lends = len(dataset)

all_dataset = dataset + fields_dataset


if __name__=='__main__':
    # 正例
    print(f'max_len=${max_len}')
    random.shuffle(all_dataset)
    train_dataset = all_dataset[0:int(lends*0.8)]
    dev_dataset = all_dataset[int(lends*0.8):]

    with open(PATH+'4/tables_train.jsonl','w',encoding='utf-8') as fout:
        for data in dataset:
            json.dump(data,fout,ensure_ascii=False)
            fout.write("\n")

    with open(PATH+'4/train.jsonl','w',encoding='utf-8') as fout:
        for data in train_dataset:
            json.dump(data,fout,ensure_ascii=False)
            fout.write("\n")

    with open(PATH+'4/dev.jsonl','w',encoding='utf-8') as fout:
        for data in dev_dataset:
            json.dump(data,fout,ensure_ascii=False)
            fout.write("\n")

    with open(PATH+'4/test.jsonl','w',encoding='utf-8') as fout:
        for data in dev_dataset:
            json.dump(data,fout,ensure_ascii=False)
            fout.write("\n")

    all_dataset = dataset+fields_dataset+dataset
    random.shuffle(all_dataset)
    with open(PATH+'4/all.jsonl','w',encoding='utf-8') as fout:
        for data in all_dataset:
            json.dump(data,fout,ensure_ascii=False)
            fout.write("\n")

