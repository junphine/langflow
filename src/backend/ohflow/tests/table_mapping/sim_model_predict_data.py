import json
import re
import random
import pymongo
import csv
import re
import collections
import sys

sys.path.append("../../src")
sys.path.append("/data/nlp/llm/CPM/")

sys.argv=['ipykernel_launcher.py',
          '--delta','/data/nlp/llm/CPM/CPM-Bee/src/results/cpm_bee_finetune-delta-best.pt',
          '--memory-limit','30'
          ]

from ohflow.interface.agents.build_embedding_index import *
import text_generation

args = text_generation.parse_args()
beam_search = text_generation.load_beam_search(args)


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

ods_dataset = read_ods_dataset(PATH+'贵州省医药监管平台ods模型.csv')

if True:
    build_table_field_embedding(collection,ods_dataset)

k=30
tp=0
tn=0
fp=0
fn=0
c=0
dataset = []


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


with open(PATH+'贵州省医药监管平台模型链路.jsonl','r',encoding='utf-8') as fd:
    for line in fd.readlines():
        row = json.loads(line)
        row['data_name_cn'] = remove_number_around(row['data_name_cn'])

        dwd_links = row['dwd_link'].split('\n')
        std_labels = []
        for dwd_link in dwd_links:
            dwd_link = remove_brackets(dwd_link).strip(';').strip()
            if dwd_link in std_dataset:
                std_labels.append(dwd_link)
        for dwd_link in std_labels:
            # std
            row2 = std_dataset[dwd_link]

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
                for index in range(0,len(datas),5):
                    query = datas[index:index+5]

                    inference_results = beam_search.generate(query, max_length=280, repetition_penalty=1)
                    for res in inference_results:
                        pred_label = res['<ans>']
                        id = labels[i]
                        true_label = result_dict[label+':'+id]
                        if pred_label=='<option_3>':
                            if true_label==pred_label:
                                tp+=1
                            else:
                                fp+=1
                                print(res)
                                res['<ans>']=true_label
                                dataset.append(res)
                            found+=1
                        else:
                            if true_label!=pred_label:
                                fn+=1
                                print(res)
                                res['<ans>']=true_label
                                dataset.append(res)
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

with open(PATH+'predict_error.jsonl','w',encoding='utf-8') as fout:
    for data in dataset:
        json.dump(data,fout,ensure_ascii=False)
        fout.write("\n")


