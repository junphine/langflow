import json
import os.path
import re
import random
import math
import collections
import pandas as pd
import csv
from ohflow.tests.table_mapping.stds.build_embedding_index import *

PATH = r'C:/TEAM/三秦/'


std_tables_file = PATH+'公卫5.0表结构文档.xlsx'
# 文件路径
file_path = PATH+'公卫_V4.6医院数据库表.xlsx'


# 读取所有工作表
xls_std = pd.ExcelFile(std_tables_file)

def remove_varchar_parentheses(sql_text):
    """
    将 SQL 中的 varchar(100) 中的括号去掉，保留 varchar
    :param sql_text: 包含 SQL 语句的字符串
    :return: 修改后的 SQL 字符串
    """
    # 使用正则表达式匹配 varchar(100)
    pattern = r"\([\d,]\)"
    # 替换为 varchar
    modified_sql = re.sub(pattern, "", sql_text, flags=re.IGNORECASE)
    return modified_sql

def read_std_csv_tables(input_file):
    std_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            row['TABLE_NAME'] = row['TABLE_NAME'].lower()
            id = row['TABLE_NAME']
            row['fields'] = {}
            std_dataset[id] = row
            id = row['TABLE_COMMENT']
            std_dataset[id] = row
    return std_dataset

def is_subset(list1, list2):
    set1 = set(list1)
    set2 = set(list2)
    return set1.issubset(set2) or set2.issubset(set1)

std_tables = read_std_csv_tables(PATH+'公卫5.0表列表.csv')
ods_tables = read_std_csv_tables(PATH+'ods_table_list.csv')
# 遍历所有工作表并读取数据
all_sheets_data = {}  # 用于存储每个工作表的数据
expected_columns = "tablename,table_commnent,name,type,comment,dict_comment,jsonb_example".split(',')

for sheet_name in xls_std.sheet_names:
    # 读取当前工作表
    df = pd.read_excel(xls_std, sheet_name=sheet_name,skiprows=0,keep_default_na=False)
    #df = df.fillna(value=None)
    # 确保列名正确
    if not is_subset(list(df.columns), expected_columns):
        print(f"Warning: Columns in sheet '{sheet_name}' do not match the expected columns.")

    # 将当前工作表的数据存储到字典中
    all_sheets_data[sheet_name] = df

std_dataset = {}
# 打印每个工作表的数据
for sheet_name, datas in all_sheets_data.items():
    print(f"Data from sheet '{sheet_name}':")

    for i,data in datas.iterrows():
        row = dict()
        table_name = data.get('tablename')
        std_table = std_tables[table_name]
        row['table_comment'] = data.get('table_commnent')
        row['table_name'] = data.get('tablename')
        row['table_schema'] = std_table.get('TABLE_SCHEMA')
        row['column_name'] = data.get('name')
        row['column_comment'] = data.get('comment')
        row['data_type'] = remove_varchar_parentheses(data.get('type'))
        row['dict_comment'] = data.get('dict_comment')
        row['jsonb_example'] = data.get('jsonb_example')
        row['_id'] = row['table_name']+'.'+row['column_name']
        std_dataset[row['_id']] = row

# 读取所有工作表
xls = pd.ExcelFile(file_path)
all_sheets_data = {}
expected_columns = "序号,字段名称,字段说明,字段类型,是否必填,备注".split(',')

for sheet_name in xls.sheet_names:
    # 读取当前工作表
    df = pd.read_excel(xls, sheet_name=sheet_name,skiprows=0,keep_default_na=False)
    #df = df.fillna(value=None)
    # 确保列名正确
    if not is_subset(list(df.columns), expected_columns):
        print(f"Warning: Columns in sheet '{sheet_name}' do not match the expected columns.")

    # 将当前工作表的数据存储到字典中
    all_sheets_data[sheet_name] = df

ods_dataset = {}
# 打印每个工作表的数据
for sheet_name, datas in all_sheets_data.items():
    print(f"Data from sheet '{sheet_name}':")
    if sheet_name not in ods_tables:
        print(datas)
        print("\n" + "-" * 50 + "\n")
        continue

    ods_table = ods_tables[sheet_name]
    for i,data in datas.iterrows():
        row = dict()
        requred = data.get('是否必填')
        if requred:
            requred = requred.strip()
        row['table_comment'] = ods_table.get('TABLE_COMMENT')
        row['table_name'] = ods_table.get('TABLE_NAME')
        row['table_schema'] = ods_table.get('TABLE_SCHEMA')
        row['column_name'] = data.get('字段名称')
        row['column_comment'] = data.get('字段说明')
        row['data_type'] = remove_varchar_parentheses(data.get('字段类型'))
        row['is_nullable'] = requred!='是'
        row['column_notes'] = data.get('备注')
        row['_id'] = row['table_name']+'.'+row['column_name']

        ods_dataset[row['_id']] = row

if __name__=='__main__':
    # 标准数据集
    header = ['_id',"table_schema","table_name","table_comment","column_name","column_comment","data_type",'dict_comment','jsonb_example']

    with open(PATH+'std_dataset.csv','w',encoding='utf-8',newline='') as fout:
        writer = csv.DictWriter(fout,header)
        writer.writeheader()
        for row in std_dataset.values():
            writer.writerow(row)

    header = ['_id',"table_schema","table_name","table_comment","column_name","column_comment","data_type",'is_required','column_notes']
    with open(PATH+'ods_dataset.csv','w',encoding='utf-8',newline='') as fout:
        writer = csv.DictWriter(fout,header,extrasaction='ignore')
        writer.writeheader()
        for id,row in ods_dataset.items():
            writer.writerow(row)

