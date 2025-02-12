import argparse
import json
import pickle
from tqdm import tqdm
import collections
import hashlib
import re
import csv


#所有匹配的字段： std+ods:1
matched_dict = {}
matched_table_dict = {}
matched_field_dict = {}


def build_question(row,row2):
    data = {}
    # ods
    data['表1'] = normal_text(row['dataset_name_cn'],row['dataset_name_en'])
    if len(row['data_name_en'])<=8 and 'x' in row['data_name_en'] or len(row['data_name_en'])<=3:
        data['字段1'] = normal_text(row['data_name_cn'],'', row['data_definition'])
    else:
        data['字段1'] = normal_text(row['data_name_cn'],row['data_name_en'],row['data_definition'])

    # std
    data['表2'] = normal_text(row2['dataset_name_cn'], row2['dataset_name_en'])
    data['字段2'] = normal_text(row2['data_name_cn'],row2['data_name_en'],row2['data_definition'])

    data["options"]= {
        "<option_0>": "表不匹配,字段不匹配",
        "<option_1>": "表匹配,字段不匹配",
        "<option_2>": "表不匹配,字段匹配",
        "<option_3>": "表匹配,字段匹配"
    }
    data["question"] = "需要把表2的字段2映射到表1的字段1，判断表1和表2,字段1和字段2是否匹配？"
    return data

def build_ans(std_row, ods_row,matched_dict,matched_field_dict,matched_table_dict):
    ans = '<option_0>'
    ods_row['data_name_cn'] = remove_number_around(ods_row['data_name_cn'])
    std_id = std_row['dataset_name_cn']+'.'+std_row['data_name_cn']
    ods_id = ods_row['dataset_name_cn']+'.'+ods_row['data_name_cn']
    if std_id+':'+ ods_id in matched_dict:
        ans = '<option_3>'
    elif std_row['dataset_name_cn']+':'+ ods_row['dataset_name_cn'] in matched_table_dict:
        ans = '<option_1>'
    elif std_row['data_name_cn']+':'+ ods_row['data_name_cn'] in matched_field_dict:
        ans = '<option_2>'
    return ans

def remove_brackets(text):
    # 使用正则表达式匹配大括号及其内部内容，并使用空字符串替换它们
    pattern = r'({.*?})'
    result = re.sub(pattern, '', text)
    return result

def standaze_field_name(field_name:str):
    if '标准码' in field_name:
        field_name = field_name.replace('标准码','编码')
    elif '标准值' in field_name:
        field_name = field_name.replace('标准值','值')
    elif '原始码' in field_name:
        field_name = field_name.replace('原始码','编码')
    elif '原始值' in field_name:
        field_name = field_name.replace('原始值','值')
    return field_name


def normal_text(*texts:str):
    out = ''
    i = 0
    for text in texts:
        text = text.lower()
        if i<2:
            text = remove_number_around(text)
        text = text.replace('<','<<')
        text = text.replace('_',' ')
        if text:
            if out:
                out += ','
            out += text
        i+=1
    return out[:100]

def remove_number_around(text):
    """
    清除给定文本前后所有的数字
    """
    # 将文本转换为小写，以便处理
    # 循环处理文本第一个和最后一个字符，直到不是数字为止
    if len(text)<3:
        return text
    while text[-1].isdigit():
        text = text[:-1]
    return text

def build_text(row):
    row['text'] = ''+ row['dataset_name_cn'] + '中的'+row['data_name_cn']+''
    row['text_en'] = 'The field '+row['data_name_en'] + ' in table '+ row['dataset_name_en']
    row['text_en'] = row['text_en'].replace('_',' ').lower()
    return row


def build_table_field_embedding(collection,dataset):

    print('Building index...')

    collection.drop()
    collection.create_index([('text','text')])
    collection.create_index([('text_embedding',{'type':'knnVector','modelId':'text2vec-large-chinese'})],name='text_embedding_knnVector')
    collection.create_index([('text_en_embedding',{'type':'knnVector','modelId':'paraphrase-xlm-r-multilingual'})],name='text_en_embedding_knnVector')

    print('Data count:', len(dataset))

    bs = 100
    c = 0
    batch = []
    for key,row in dataset.items():
        c+=1
        row = build_text(row)
        if len(row['text'])<8:
            continue
        #rank==1: 459466
        if row['text']:
            row['_id'] = key
            row['text_embedding'] = row['text']
            row['text_en_embedding'] = row['text_en']
            batch.append(row)
            if len(batch) >= bs:
                try:
                    collection.insert_many(batch)
                    batch.clear()
                except Exception as e:
                    batch.clear()
                    print(e)
            elif bs==1:
                try:
                    collection.insert_one(row)
                except Exception as e:
                    print(e)

    if batch:
        collection.insert_many(batch)

    print('Index written!')


def read_ods_dataset(input_file):
    ods_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            row['data_name_cn'] = remove_number_around(row['data_name_cn'])
            id = row['dataset_name_cn']+'.'+row['data_name_cn']
            ods_dataset[id] = row
    return ods_dataset

def read_ods_tables(input_file):
    ods_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            id = row['dataset_name_cn']
            id = remove_number_around(id)
            row['dataset_name_cn'] = id
            ods_dataset[id] = row
    return ods_dataset


def read_std_dataset(input_file):
    std_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            row['dataset_name_en'] = row['dataset_name_en'].lower()
            row['data_name_en'] = remove_number_around(row['data_name_en']).lower()
            row['data_name_cn'] = remove_number_around(row['data_name_cn'])
            field_name = standaze_field_name(row['data_name_cn'])
            id = row['dataset_name_cn']+'.'+field_name
            std_dataset[id] = row
            id_en = row['dataset_name_en']+'.'+row['data_name_en']
            std_dataset[id_en] = row
    return std_dataset

def read_std_tables(input_file):
    std_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            row['dataset_name_en'] = row['dataset_name_en'].lower()
            id = row['dataset_name_cn']
            id = remove_number_around(id)
            row['dataset_name_cn'] = id
            std_dataset[id] = row
    return std_dataset


