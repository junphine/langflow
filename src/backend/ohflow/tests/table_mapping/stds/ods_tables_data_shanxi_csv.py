import json
import os.path
import re
import random
import math
import collections
import csv
from ohflow.tests.table_mapping.stds.build_embedding_index import *

PATH = r'C:/TEAM/三秦/'
# 字段是否使用注释

# 文件路径
file_path = PATH+'tables_output.csv'


def remove_varchar_parentheses(sql_text):
    """
    将 SQL 中的 varchar(100) 中的括号去掉，保留 varchar
    :param sql_text: 包含 SQL 语句的字符串
    :return: 修改后的 SQL 字符串
    """
    # 使用正则表达式匹配 varchar(100)
    pattern = r"\([\d,]+\)"
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

def read_std_txt_tables(input_file):
    std_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        lines = f.readlines()
        # 遍历文件中的每一行
        for line in lines:
            if not line or len(line)<4:
                continue
            line = line.replace('\xa0','')
            parts0 = re.split(r'\s+',line)
            parts = re.split(r'\s*（',parts0[1])

            row = {}
            row['TABLE_COMMENT'] = parts[0]
            if len(parts)==1:
                row['TABLE_NAME'] = parts0[2].lstrip('（').rstrip('）')
            else:
                row['TABLE_NAME'] = parts[1].lstrip('（').rstrip('）')
            id = row['TABLE_NAME']
            row['fields'] = {}
            std_dataset[id] = row
    return std_dataset

def read_std_csv_columns(input_file,tables):
    expected_columns = "序号,字段名称,字段说明,字段类型,是否必填,备注".split(',')
    ods_dataset = collections.OrderedDict()
    i = 0
    table_list = list(tables.keys())
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        sheet_name = table_list[i]
        ods_table = ods_tables[sheet_name]
        for data in reader:
            row = dict()
            no = data.get('序号')
            if no=='':
                continue
            if no=='序号':
                i+=1
                sheet_name = table_list[i]
                print(f"Data from sheet '{sheet_name=}':{i}")
                if sheet_name not in ods_tables:
                    print(sheet_name)
                    print("\n" + "-" * 50 + "\n")

                ods_table = ods_tables[sheet_name]
                continue

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
    return ods_dataset


ods_tables = read_std_txt_tables(PATH+'ods_table_list.txt')
# 遍历所有工作表并读取数据
ods_dataset = read_std_csv_columns(PATH+'tables_output.csv',ods_tables)


if __name__=='__main__':
    # ODS数据集

    header = ['_id',"table_schema","table_name","table_comment","column_name","column_comment","data_type",'is_required','column_notes']
    with open(PATH+'ods_dataset.csv','w',encoding='utf-8',newline='') as fout:
        writer = csv.DictWriter(fout,header,extrasaction='ignore')
        writer.writeheader()
        for id,row in ods_dataset.items():
            writer.writerow(row)

