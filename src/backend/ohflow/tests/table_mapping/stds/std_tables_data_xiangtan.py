import copy
import json
import re
import random
import os
import collections
from ohflow.tests.table_mapping.stds.build_embedding_index import *

PATH = r'C:/TEAM/湘潭项目仁医部分/'
# 字段是否使用注释
use_field_desc = not True
dataset_mapping_prompt = {}
std_tables = read_std_tables(PATH+'湘潭数据模型-目录.csv')
std_dataset = read_std_dataset(PATH+'湘潭数据模型.csv')
for id,row in std_dataset.items():
    if row['dataset_name_cn'] not in std_tables:
        continue
    field_name = standaze_field_name(row['data_name_cn'])
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

table_list="""
ZY_ZYJS
ZY_BRRY
GY_KSDM
YB_ZYJSXX
MS_MZXX
YS_MZ_JZLS
YB_MZJSXX
WITH_MS_SFMX
MS_SJFP
MS_GHMX
GY_SFXM
MS_SFMX
GY_YGDM
MS_YYGH
BA_BRSY
ZY_FYMX_JS
GY_YLML
YK_YPCD
ZY_FYMX
YK_YPML
GY_YLML
""".split('\n')
ods_tables = {}
ods_en_tables = {}
ods_dataset = {}

def read_txt_ods_dataset(input_file):
    ods_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        lines = f.readlines()
        # 遍历文件中的每一行
        for line in lines:
            parts = re.split('\s+',line.strip())
            if len(parts)>=2:
                if len(parts)>=3:
                    table = parts[-2]
                    table_cn = parts[-1]
                    ods_tables[table_cn] = dict(dataset_name_cn=table_cn,dataset_name_en=table)
                    ods_en_tables[table] = dict(dataset_name_cn=table_cn,dataset_name_en=table)
                    row = ods_tables[table_cn]
                else:
                    row = copy.copy(row)
                    row['dataset_name_cn'] = table_cn
                    row['data_name_en'] = remove_number_around(parts[0])
                    row['data_name_cn'] = remove_number_around(parts[1])
                    id = row['dataset_name_cn']+'.'+row['data_name_cn']
                    ods_dataset[id] = row
    return ods_dataset

def read_csv_ods_dataset(input_file):
    ods_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        lines = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in lines:

            if row['source_column'] and row['source_column_cn']:
                columns = row['source_column'].split(',')
                columns_cn = row['source_column_cn'].split(',')

                tables = row['source_table'].upper()
                tables = tables.split(',')

                if len(tables)==1 and len(columns)>1:
                    tables = tables*len(columns)

                for col,col_cn,table in zip(columns,columns_cn,tables):
                    col = col.strip().strip('?')
                    col_cn = col_cn.strip()
                    table = table.strip()
                    if table not in ods_en_tables:
                        table_cn = table
                        ods_tables[table_cn] = dict(dataset_name_cn=table_cn,dataset_name_en=table)
                        ods_en_tables[table] = dict(dataset_name_cn=table_cn,dataset_name_en=table)
                    else:
                        table_cn = ods_en_tables[table]['dataset_name_cn']
                        ods_tables[table_cn] = dict(dataset_name_cn=table_cn,dataset_name_en=table)
                    row = copy.copy(row)
                    row['dataset_name_cn'] = table_cn
                    row['dataset_name_en'] = table
                    row['data_name_en'] = remove_number_around(col)
                    row['data_name_cn'] = remove_number_around(col_cn)
                    id = row['dataset_name_cn']+'.'+row['data_name_cn']
                    ods_dataset[id] = row
    return ods_dataset


ods_dataset= read_txt_ods_dataset(PATH+'input_shiwu.csv')
#ods_tables = read_ods_tables(PATH+'ods-table-list.csv')
#ods_dataset = read_ods_dataset(PATH+'ods-columns-list.csv')
"""
for row in ods_dataset.values():
    table_name = row['dataset_name_cn']
    field_name = row['data_name_cn']
    if table_name not in ods_tables:
        continue
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
    for table in ods_tables.values():
        if table['dataset_name_en']==en:
            return table['dataset_name_cn']
    else:
        return en

def oc(en,table):
    table = ot(table)
    if table in ods_tables:
        fields = ods_tables[table]['fields']
        for f in fields.values():
            if f['data_name_en']==en:
                return f['data_name_cn']
    return en

def st(en):
    for table in std_tables.values():
        if en==table['dataset_name_en']:
            return table['dataset_name_cn']
    return en

def sc(en,table):
    table = st(table)
    en = en.lower()
    if table in std_tables:
        fields = std_tables[table]['fields']
        for f in fields.values():
            if f['data_name_en']==en:
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

# 全是英文字段

dataset = []
fields_dataset = []
c = 0
mappinf_file = PATH+'视图解析出来的映射关系.csv'

#计算召回率，目标字段在标准库表找到结果则为字段名
matched_dict={}
matched_target_field_dict = {} # target_table.field->(source_table,source_column)

if os.path.exists(mappinf_file):
    with open(mappinf_file,'r',encoding='utf-8') as fd:
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

            columns = row['source_column'].upper()
            tables = row['source_table'].upper()

            matched_target_field_dict[dwd_link] = (tables,columns)



if __name__=='__main__':

    # 正例
    print(f'max_len=${max_len}')

    header = 'dataset_name_en,dataset_name_cn,data_name_cn,data_name_en,id,数据类型,长度,填报要求,data_definition,值域'.split(',')
    print(f'max_len=${max_len}')
    with open(PATH+'std_dataset.csv','w',encoding='utf-8',newline='') as fout:
        writer = csv.DictWriter(fout,header)
        writer.writeheader()
        for row in std_dataset.values():
            row['id'] = row['dataset_name_en']+'.'+row['data_name_en']
            writer.writerow(row)

    header = 'dataset_name_en,dataset_name_cn,data_name_cn,data_name_en,id'.split(',')
    with open(PATH+'ods_dataset.csv','w',encoding='utf-8',newline='') as fout:
        writer = csv.DictWriter(fout,header,extrasaction='ignore')
        writer.writeheader()
        for id,row in ods_dataset.items():
            if row['dataset_name_en'] in table_list:
                row['id'] = row['dataset_name_en']+'.'+row['data_name_en']
                writer.writerow(row)




