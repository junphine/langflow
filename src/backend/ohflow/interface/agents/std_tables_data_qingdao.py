import json
import os.path
import re
import random
import math
import collections
import pandas as pd
from ohflow.interface.agents.build_embedding_index import *

PATH = r'C:/TEAM/青岛-七医新/'
# 字段是否使用注释
use_field_desc=not True
dataset_mapping_prompt = {}

std_tables = read_std_tables(PATH+'数据中心资产目录V1.1.csv')
# 文件路径
file_path = PATH+'数据中心资产表结构V1.1.xlsx'

# 读取所有工作表
xls = pd.ExcelFile(file_path)

def is_subset(list1, list2):
    set1 = set(list1)
    set2 = set(list2)
    return set1.issubset(set2) or set2.issubset(set1)

# 遍历所有工作表并读取数据
all_sheets_data = {}  # 用于存储每个工作表的数据

for sheet_name in xls.sheet_names:
    # 读取当前工作表
    df = pd.read_excel(xls, sheet_name=sheet_name,skiprows=1)

    # 确保列名正确
    expected_columns = ['卫生部数据元标识符', '数据项', '字段', '字段名', '类型', '长度', '填报要求', '说明', '备注']
    if not is_subset(list(df.columns), expected_columns):
        print(f"Warning: Columns in sheet '{sheet_name}' do not match the expected columns.")

    # 将当前工作表的数据存储到字典中
    all_sheets_data[sheet_name] = df

std_dataset = {}
# 打印每个工作表的数据
for sheet_name, datas in all_sheets_data.items():
    print(f"Data from sheet '{sheet_name}':")
    if sheet_name not in std_tables:
        print(datas)
        print("\n" + "-" * 50 + "\n")
        continue

    std_table = std_tables[sheet_name]
    for i,data in datas.iterrows():
        row = dict()
        row['dataset_name_cn'] = sheet_name
        row['dataset_name_en'] = std_table['dataset_name_en']
        row['dataset_desc'] = std_table.get('dataset_desc')
        row['data_name_cn'] = data.get('数据项',data.get('字段'))
        row['data_name_en'] = data.get('字段名')
        row['data_definition'] = data.get('说明')
        if not isinstance(row['data_name_cn'],str) or not isinstance(row['data_name_en'],str):
            continue
        row['full_name_cn'] = row['dataset_name_cn']+'.'+row['data_name_cn']
        id = row['full_name_cn']
        field_name = standaze_field_name(row['data_name_cn'])
        std_dataset[id] = row
        std_table = std_tables[row['dataset_name_cn']]
        fields = std_table.get('fields', {})
        if len(fields)==0:
            std_table['fields'] = fields
        fields[field_name] = row


# 构建提示词模板： tables

table_mapping_prompt = f'\n标准库中定义了如下表：\n'
table_mapping_prompt += f'| 表英文名 | 表中文名 |\n'
for table_name,table in std_tables.items():
    table_name_en = table['dataset_name_en']
    table_name_cn = table['dataset_name_cn']
    table_desc = table.get('dataset_desc')
    table_mapping_prompt += f'| {table_name_en} | {table_name_cn} '
    if table_desc:
        table_mapping_prompt += f' | {table_desc} '
    table_mapping_prompt += '|\n'

    fields = table.get('fields', {})
    prompt = f'标准库中表"{table_name}"的表字段信息如下：\n'
    if use_field_desc:
        prompt += f'| 字段英文名 | 字段中文名 | 字段注释 |\n'
    else:
        prompt += f'| 字段英文名 | 字段中文名 |\n'
    i = 1
    for fname,field in fields.items():
        data_desc= field.get("data_definition")
        prompt += f'| {field["data_name_en"]} | {field["data_name_cn"]} '
        if use_field_desc and data_desc:
            prompt += f' | {data_desc} '
        prompt += '|\n'
        i += 1
    dataset_mapping_prompt[table_name] = prompt

std_keys = list(std_dataset.keys())

ods_tables = read_ods_tables(PATH+'七医新HIS表列表.csv')
ods_en_tables = read_ods_tables(PATH+'七医新HIS表列表.csv',use_cn_name=False)
ods_dataset = read_ods_dataset(PATH+'七医新HIS表结构.csv')

for row in ods_dataset.values():
    table_cn = row['dataset_name_cn']
    table_name_en = row['dataset_name_en']
    field_name = row['data_name_cn']
    if table_cn not in ods_tables:
        continue
        #ods_tables[table_cn] = dict(dataset_name_cn=table_cn,dataset_name_en=table_name_en)

    fields = ods_tables[table_cn].get('fields', {})
    if len(fields)==0:
        ods_tables[table_cn]['fields'] = fields
    fields[field_name] = row

max_len = 0

# 返回询问ods_table的提示词
def table_mapping_question(ods_table:str):
    input_str = ods_table
    if isinstance(ods_table,str):
        ods_table = ods_tables.get(ods_table)
    if ods_table is not None:
        name = ods_table['dataset_name_cn']
        input_str = f'(表英文名:{ods_table["dataset_name_en"]},表中文名:{name})'
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
        desc = ods_field.get("data_definition","")
        if desc:
            desc = ', 注释：'+ desc
        input_str = f'(英文名:{ods_field["data_name_en"]},中文名:{name}{desc})'
    prompt_prefix = ''
    if isinstance(std_table,str):
        prompt_prefix = dataset_mapping_prompt[std_table]
    else:
        for tab in std_table:
            prompt_prefix += dataset_mapping_prompt[tab]
            prompt_prefix += "\n"
    prompt = prompt_prefix+ f'从所给标准库的表中选出与业务表"{input_table}"的字段"{input_str}"可以映射对应的字段，只需返回字段中文名，允许多选，若无匹配字段，则返回无。\n'
    return dict(prompt=prompt)


def ot(en):
    en = en.lower()
    for table in ods_tables.values():
        if table['dataset_name_en'].lower()==en:
            return table['dataset_name_cn']
    else:
        return en

def oc(en,table):
    en = en.lower()
    table = ot(table)
    if table in ods_tables:
        fields = ods_tables[table]['fields']
        for f in fields.values():
            if f['data_name_en'].lower()==en:
                return f['data_name_cn']
    return en

def st(en):
    en = en.lower()
    for table in std_tables.values():
        if en==table['dataset_name_en'].lower():
            return table['dataset_name_cn']
    return en

def sc(en,table):
    table = st(table)
    en = en.lower()
    if table in std_tables:
        fields = std_tables[table]['fields']
        for f in fields.values():
            if f['data_name_en'].lower()==en:
                return f['data_name_cn']
    return en


def _ote(cn):
    if cn in ods_tables:
        return ods_tables[cn]['dataset_name_en']
    else:
        return cn

def _oce(cn,table):
    if table in ods_tables:
        fields = ods_tables[table]['fields']
        for f in fields.values():
            if f['data_name_cn']==cn:
                return f['data_name_en']
    return cn

def _ste(cn):
    for table in std_tables.values():
        if cn==table['dataset_name_cn']:
            return table['dataset_name_en']
    return cn

def _sce(cn,table):
    if table in std_tables:
        fields = std_tables[table]['fields']
        for f in fields.values():
            if f['data_name_cn']==cn:
                return f['data_name_en']
    return cn

#所有匹配的字段： std+ods:1
matched_dict = {} # std_table.field+ods_table.field:1
matched_table_dict = {} # std_table+ods_table:1
matched_field_dict = {} # std_field+ods_field:1
#计算召回率，ods字段在标准库表找到结果则为字段名
matched_ods_field_table_dict = {} # ods_table.field+std_table:1
dataset = []
fields_dataset = []

c = 0
mappinf_file = PATH+'ai_mapping_ods_predict_result.csv'
if os.path.exists(mappinf_file):
    with open(PATH+'ai_mapping_ods_predict_result.csv','r',encoding='utf-8') as fd:
        reader = csv.DictReader(fd)
        for row in reader:

            row['target_table'] = row['target_table'].lower()
            row['target_column'] = remove_number_around(row['target_column'])

            dwd_link = row['target_table'] +'.'+row['target_column'] # std
            dwd_link = dwd_link.lower()

            if row['source_column']=='' or row['source_column']=='-':
                continue
            if row['source_table']=='' or row['source_table']=='-':
                continue


            columns = row['source_column'].split(',')
            columns_cn = row['source_column_cn'].split(',')

            tables = row['source_table'].upper()
            tables = tables.split(',')

            if len(tables)==1 and len(columns)>1:
                tables = tables*len(columns)

            for col,col_cn,table in zip(columns,columns_cn,tables):
                row['data_name_en'] = col.strip().strip('?')
                row['data_name_cn'] = col_cn.strip().strip('?')
                row['dataset_name_en'] = table = table.strip()
                if row['dataset_name_en'] not in ods_en_tables:
                    print("not found ods table "+row['dataset_name_en'])
                    continue
                source_id = ot(table)+'.'+oc(row['data_name_en'],table) # ods
                std_labels = []
                if dwd_link.lower() in std_dataset:
                    std_labels.append(dwd_link)
                    c+=1
                else:
                    print("not found std table.column "+dwd_link)

                for dwd_link in std_labels:
                    dwd_link_cn = st(row['target_table'])+'.'+sc(row['target_column'],row['target_table'])
                    dwd_link = standaze_field_name(dwd_link)
                    if dwd_link in std_dataset:
                        row_std = std_dataset[dwd_link]
                        table_match_id = st(row_std['dataset_name_en'])+':'+ot(row['dataset_name_en'])
                        if table_match_id in matched_table_dict:
                            matched_table_dict[table_match_id]+=1
                        else:
                            matched_table_dict[table_match_id]=1
                            if len(std_labels)>0:
                                ods_table = ods_en_tables[row['dataset_name_en']]
                                data = table_mapping_question(ods_table)
                                data["anser"] = row_std['dataset_name_cn']
                                dataset.append(data)
                        std_field_name = standaze_field_name(sc(row_std['data_name_en'],row_std['dataset_name_en']))
                        field_match_id = std_field_name+':'+oc(row['data_name_en'],row['dataset_name_en'])
                        if field_match_id in matched_field_dict:
                            matched_field_dict[field_match_id]+=1
                        else:
                            matched_field_dict[field_match_id]=1


                        if dwd_link_cn+':'+source_id in matched_dict:
                            matched_dict[dwd_link_cn+':'+source_id]+=1
                        else:
                            matched_dict[dwd_link_cn+':'+source_id]=1
                            #正例多生成几份
                            ods_table = ods_en_tables[row['dataset_name_en']]
                            data = field_mapping_question(ods_table,row,row_std['dataset_name_cn'])
                            data["anser"] = std_field_name
                            fields_dataset.append(data)

                        ods_table = ods_en_tables[row['dataset_name_en']]
                        ods_table['data_name_cn_from_sql'] = row['data_name_cn']

                        matched_ods_field_table_dict[source_id+':'+st(row_std['dataset_name_en'])] = std_field_name
                        matched_ods_field_table_dict[source_id] = std_field_name
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

