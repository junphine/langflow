import json
import os.path
import re
import random
import math
import collections
import pandas as pd
import csv
from ohflow.interface.data.word_extract import  *

PATH = r'C:/TEAM/三秦/'
# 字段是否使用注释
use_field_desc=not True
dataset_mapping_prompt = {}

std_tables_file = PATH+'公卫5.0表结构文档.xlsx'
# 文件路径
file_path = PATH+'公卫_V4.6医院数据库表.xlsx'

# 使用示例
if __name__ == "__main__":
    # 替换为你的Word文档路径
    doc_path = PATH+"公卫_V4.6医院数据库表.docx"

    # 提取数据并保存CSV
    tables = extract_word_tables(
        file_path=doc_path,
        output_csv="output.csv"
    )

    # 打印第一个表格的前两行
    print("\n示例数据：")
    for row in tables[0][:2]:
        print(row)