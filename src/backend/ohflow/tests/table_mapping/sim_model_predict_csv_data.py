import json
import re
import random
import pymongo
import csv
import re
import collections
import sys
import numpy as np
from typing import Any, Callable, Dict, List, Optional, Set, Tuple, Union

sys.path.append("../../src")
sys.path.append("/data/nlp/llm/CPM/")

sys.argv=['ipykernel_launcher.py',
          '--delta','/data/nlp/llm/CPM/CPM-Bee/src/results/cpm_bee_finetune-delta-best.pt',
          '--memory-limit','30'
          ]

from ohflow.interface.agents.build_embedding_index import *
import text_generation
"""
生成匹配结果：

"""

args = text_generation.parse_args()
beam_search = text_generation.load_beam_search(args)


header = 'ods_dataset_cn,ods_data_cn,std_dataset_cn,std_data_cn,pred_match,human_match'.split(',')

PATH = r'C:/TEAM/贵州医药监管平台/'
PATH = r'data/'


db_uri = 'mongodb://172.16.29.84:2701/graph'
mongo_client = pymongo.MongoClient(db_uri)
db = mongo_client.get_default_database()

collection_name = 'meta_info'
collection = db[collection_name]

std_dataset = collections.OrderedDict()
with open(PATH+'标化模型.jsonl','r',encoding='utf-8') as fd:
    for line in fd.readlines():
        row = json.loads(line)
        id = row['full_name_cn']
        std_dataset[id] = row

std_keys = list(std_dataset.keys())

ods_dataset = read_ods_dataset(PATH+'贵州省医药监管平台ods模型.csv')

#所有匹配的字段： std+ods:1
matched_dict = {}
matched_table_dict = {}
matched_field_dict = {}
result_dict = {}
with open(PATH+'贵州省医药监管平台模型链路.jsonl','r',encoding='utf-8') as fd:
    for line in fd.readlines():
        row = json.loads(line)
        row['data_name_cn'] = remove_number_around(row['data_name_cn'])
        label = row['dataset_name_cn']+'.'+row['data_name_cn'] # ods
        dwd_links = row['dwd_link'].split('\n')

        for dwd_link in dwd_links:
            dwd_link = remove_brackets(dwd_link).strip(';').strip()
            if dwd_link in std_dataset:
                row_std = std_dataset[dwd_link]
                matched_dict[dwd_link+':'+label]=1
                matched_table_dict[row_std['dataset_name_cn']+':'+row['dataset_name_cn']]=1
                matched_field_dict[row_std['data_name_cn']+':'+row['data_name_cn']]=1

k=30
tp=1
tn=0
fp=0
fn=0
c=0
dataset = []


# 遍历标化模型，生成匹配结果

# key:ods
std_matched_dict = collections.defaultdict(list)

if std_dataset:
    for row2 in std_dataset.values():
        if c<11:
            # std
            row2 = build_text(row2)
            query = row2['text']
            query_en = row2['text_en']
            label = row2['dataset_name_cn']+'.'+row2['data_name_cn'] # std
            selector = dict(text_embedding={'$text':query,'$limit':k})
            result = collection.find(selector)
            query_results = collections.OrderedDict()
            for doc in result:
                id = doc['_id']
                ods_row = ods_dataset[id]
                text_embedding = doc['text_embedding']
                distance = doc['_meta']['searchScore']
                if distance<0.8:
                    data = build_question(ods_row,row2)
                    result_dict[label+':'+id] = build_ans(row2,ods_row,matched_dict,matched_field_dict,matched_table_dict)
                    data["<ans>"] = ''

                    query_results[id]= data

            selector = dict(text_en_embedding={'$text':query_en,'$limit':k})
            result = collection.find(selector)
            for doc in result:
                id = doc['_id']
                ods_row = ods_dataset[id]
                text_embedding = doc['text_embedding']
                distance = doc['_meta']['searchScore']
                if distance<0.8:
                    data = build_question(ods_row,row2)
                    result_dict[label+':'+id] = build_ans(row2,ods_row,matched_dict,matched_field_dict,matched_table_dict)
                    data["<ans>"] = ''

                    query_results[id]= data

            if query_results:
                found=0
                i = 0
                labels = list(query_results.keys())
                datas = list(query_results.values())
                for index in range(0,len(datas),4):
                    query = datas[index:index+4]
                    inference_results = beam_search.generate(query, max_length=280, repetition_penalty=1)
                    #inference_results = query
                    for res in inference_results:
                        id = labels[i]
                        pred_label = res['<ans>']
                        true_label = result_dict[label+':'+id]
                        parts = id.split('.')
                        if pred_label=='<option_3>':
                            if true_label == pred_label:
                                tp+=1
                            else:
                                fp+=1
                            data = dict(std_dataset_cn=row2['dataset_name_cn'],std_data_cn=row2['data_name_cn'],
                                        ods_dataset_cn=parts[0],ods_data_cn=parts[1],pred_match=pred_label,human_match=true_label)
                            std_matched_dict[id].append(data)
                            found+=1
                        elif true_label=='<option_3>':
                            if true_label != pred_label:
                                fn+=1
                                data = dict(std_dataset_cn=row2['dataset_name_cn'],std_data_cn=row2['data_name_cn'],
                                            ods_dataset_cn=parts[0],ods_data_cn=parts[1],pred_match=pred_label,human_match=true_label)
                                std_matched_dict[id].append(data)
                            else:
                                tn+=1
                        else:
                            tn+=1
                        i+=1

            c+=1
            if c%100==0:
                print('#tp='+str(tp))
                print('#tn='+str(tn))
                print('#fp='+str(fp))
                print('#fn='+str(fn))
                print('#total='+str(c))
                print(f'#Precision={tp/(tp+fp)}')
                print(f'#Recall={tp/(tp+fn)}')


lends = len(dataset)
print('tp='+str(tp))
print('tn='+str(tn))
print('fp='+str(fp))
print('fn='+str(fn))
print(f'Precision={tp/(tp+fp)}')
print(f'Recall={tp/(tp+fn)}')
print('total='+str(c))

with open(PATH+'std_predict_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,header)
    writer.writeheader()
    for items in std_matched_dict.values():
        writer.writerows(items)


with open(PATH+'ods_predict_result.csv', 'w', encoding='utf-8',newline='') as f:
    writer = csv.DictWriter(f,header)
    writer.writeheader()
    for row in ods_dataset.values():
        label = row['dataset_name_cn']+'.'+row['data_name_cn']
        if label in std_matched_dict:
            writer.writerows(std_matched_dict[label])
        else:
            writer.writerow(dict(ods_dataset_cn=row['dataset_name_cn'],ods_data_cn=row['data_name_cn'],
                                 std_dataset_cn='',std_data_cn='',pred_match='',human_match=''))



