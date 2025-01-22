import json
import re
import random
import pymongo
from ohflow.interface.agents.build_embedding_index import *

PATH = r'C:/TEAM/贵州医药监管平台/'

db_uri = 'mongodb://172.16.29.84:2701/graph'
mongo_client = pymongo.MongoClient(db_uri)
db = mongo_client.get_default_database()

collection_name = 'meta_info'
collection = db[collection_name]

std_dataset = {}
with open(PATH+'标化模型.jsonl','r',encoding='utf-8') as fd:
    for line in fd.readlines():
        row = json.loads(line)
        id = row['full_name_cn']
        std_dataset[id] = row

std_keys = list(std_dataset.keys())


k=30
t=0
c=0
dataset = []
with open(PATH+'贵州省医药监管平台模型链路.jsonl','r',encoding='utf-8') as fd:
    for line in fd.readlines():
        row = json.loads(line)

        dwd_links = row['dwd_link'].split('\n')
        for dwd_link in dwd_links:
            if '原始码' in dwd_link:
                continue
            dwd_link = remove_brackets(dwd_link).strip(';').strip()
            if dwd_link in std_dataset:
                data = {}
                data['表1'] = normal_text(row['dataset_name_cn']+','+row['dataset_name_en'])
                if 'x' in row['data_name_en'] or len(row['data_name_en'])<=3:
                    data['字段1'] = normal_text(row['data_name_cn']+','+row['data_definition'])
                else:
                    data['字段1'] = normal_text(row['data_name_cn']+','+row['data_name_en']+','+row['data_definition'])

                row2 = std_dataset[dwd_link]
                data['表2'] = normal_text(row2['dataset_name_cn']+','+row2['dataset_name_en'])
                data['字段2'] = normal_text(row2['data_name_cn']+','+row2['data_name_en']+','+row2['data_definition'])
                data["<ans>"] = '<option_2>'
                row2 = build_text(row2)
                query = row2['text']
                query_en = row2['text_en']
                label = build_text(row)['text']
                selector = dict(text_embedding={'$text':query,'$limit':k})
                result = collection.find(selector)
                query_results = []
                found = 0
                for doc in result:
                    text = doc['text']
                    text_embedding = doc['text_embedding']
                    distance = doc['_meta']['searchScore']
                    if distance<1:
                        if text_embedding==label:
                            t+=1
                            dataset.append(data)
                            found+=1
                            break
                if found==0:
                    selector = dict(text_en_embedding={'$text':query_en,'$limit':k})
                    result = collection.find(selector)
                    query_results = []
                    for doc in result:
                        text = doc['text']
                        text_embedding = doc['text_embedding']
                        distance = doc['_meta']['searchScore']
                        if distance<1:
                            if text_embedding==label:
                                t+=1
                                dataset.append(data)
                                break
                c+=1

            else:
                print(dwd_link)
                continue


lends = len(dataset)
print('t='+str(t))
print(',c='+str(c))

with open(PATH+'predict.jsonl','w',encoding='utf-8') as fout:
    for data in dataset:
        json.dump(data,fout,ensure_ascii=False)
        fout.write("\n")


