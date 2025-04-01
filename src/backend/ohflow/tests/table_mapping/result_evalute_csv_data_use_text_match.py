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

ENDPOINT = "auto_mapping" # The endpoint name of the flow

"""
生成匹配结果：

"""

header = 'ods_dataset_cn,ods_dataset_en,ods_data_cn,ods_data_en,std_dataset_cn,std_dataset_en,std_data_cn,std_data_en,humans,humans_data_cn'.split(',')
PATH = r'C:/TEAM/湘潭项目仁医部分/'
PATH = r'C:/TEAM/青岛-七医新/'

tp=1
tn=0 #实际为负类的样本被正确地分类为负类的数量。
fp=0 #实际为负类的样本被错误地分类为正类的数量
fn=0 #实际为正类的样本被错误地分类为负类的数量
inc=0
c=0
std_result_dataset = {}
with open(PATH+ENDPOINT+'_result.json','r',encoding='utf-8') as fd:
    std_result_dataset = json.load(fd)

# 遍历标化模型，生成匹配结果

from ohflow.interface.agents.build_embedding_index import *
import ohflow.interface.agents.std_tables_data_qingdao as meta_data

dwd_matched_dict = {}
ods_matched_dict = {}
c = 0
mappinf_file = PATH+'sql_parsed_result.csv'

with open(mappinf_file,'r',encoding='utf-8') as fd:
    reader = csv.DictReader(fd)
    for row in reader:

        row['target_table'] = row['target_table'].lower()
        row['target_column'] = remove_number_around(row['target_column'])
        # 中文名
        dwd_link = meta_data.st(row['target_table']) +'.'+meta_data.sc(row['target_column'],row['target_table']) # std
        dwd_link = dwd_link.lower()

        if row['source_column']=='' or row['source_column']=='-':
            continue
        if row['source_table']=='' or row['source_table']=='-':
            continue

        columns = row['source_column'].upper()

        tables = row['source_table'].upper()
        if dwd_link not in matched_dict:
            dwd_matched_dict[dwd_link] = [tables,columns]
        else:
            dwd_matched_dict[dwd_link] = [dwd_matched_dict[dwd_link][0]+','+tables,dwd_matched_dict[dwd_link][1]+','+columns]

        # 中文名
        src_link = meta_data.ot(row['source_table']) +'.'+meta_data.oc(row['source_column'],row['source_table']) # std
        src_link = src_link.lower()

        columns = row['target_column'].upper()

        tables = row['target_table'].upper()
        if src_link not in matched_dict:
            ods_matched_dict[src_link] = [tables,columns]
        else:
            ods_matched_dict[src_link] = [ods_matched_dict[src_link][0]+','+tables,ods_matched_dict[src_link][1]+','+columns]



# key:ods_table,value:list[dict(std_data_name,ods_data_name)]
std_matched_dict = collections.defaultdict(list)
std_matched_error_dict = collections.defaultdict(list)
if std_result_dataset:
    for ods_table,row2 in std_result_dataset.items():
        if isinstance(row2,str):
            continue
        m_std_tables:list = row2['std_table']
        for field,m_fields in row2.items():
            if field=='std_table':
                continue
            m_fields.sort(key=lambda x: x[0])
            ods_table_en = meta_data._ote(ods_table)
            ods_field_en = meta_data._oce(field,ods_table)
            if m_fields==[]:
                match_ods_id = ods_table+'.'+field

                if match_ods_id in ods_matched_dict:
                    std_en = ods_matched_dict[match_ods_id]
                    std_table,std_field = std_en
                    item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn='',std_data_cn='',humans_data_cn=std_en[1])
                    std_matched_error_dict[ods_table].append(item)
                    fn+=1

                for dwd_link,ods_en in dwd_matched_dict.items():
                    if ods_table_en in ods_en[0] and ods_field_en in ods_en[1]:
                        std_table,std_field = m_field.split('.',1)
                        item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn='',std_data_cn='',humans_data_cn=ods_en[1])
                        std_matched_error_dict[ods_table].append(item)
                        fn+=1

            i=0
            for m_pos_field in m_fields[0:5]:
                m_field = m_pos_field[1]
                std_table,std_field = m_field.split('.',1)
                if i>0 and ('费' in std_field or '姓名' in std_field or '时间' in std_field or '地址' in std_field):
                    break
                item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn=std_table,std_data_cn=std_field,humans=0)
                match_id = std_table+'.'+std_field

                if match_id in dwd_matched_dict:
                    ods_en = dwd_matched_dict[match_id]
                    if ods_table_en in ods_en[0] and ods_field_en in ods_en[1]:
                        item["humans"] = 1
                        tp+=1
                    else:
                        std_matched_error_dict[ods_table].append(item)
                        fp+=1
                else:
                    if field in std_field:
                        tp+=1
                    else:
                        inc+=1

                std_matched_dict[ods_table].append(item)
                i+=1

        c+=1

fn = len(ods_matched_dict)
lends = len(std_matched_dict)
print('tp='+str(tp))
print('tn='+str(tn))
print('fp='+str(fp))
print('fn='+str(fn))
print('inc='+str(inc))
print(f'Precision={tp/(tp+fp)}')
print(f'Recall={tp/(tp+fn)}')
print('total='+str(c))

with open(PATH+ENDPOINT+'_ods_predict_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,header)
    writer.writeheader()
    for items in std_matched_dict.values():
        for item in items:
            item['ods_dataset_en'] = meta_data._ote(item['ods_dataset_cn'])
            item['ods_data_en'] = meta_data._oce(item['ods_data_cn'],item['ods_dataset_cn'])
            item['std_dataset_en'] = meta_data._ste(item['std_dataset_cn'])
            item['std_data_en'] = meta_data._sce(item['std_data_cn'],item['std_dataset_cn'])
        writer.writerows(items)

with open(PATH+ENDPOINT+'_ods_predict_error_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,header)
    writer.writeheader()
    for items in std_matched_error_dict.values():
        for item in items:
            item['ods_dataset_en'] = meta_data._ote(item['ods_dataset_cn'])
            item['ods_data_en'] = meta_data._oce(item['ods_data_cn'],item['ods_dataset_cn'])
            item['std_dataset_en'] = meta_data._ste(item['std_dataset_cn'])
            item['std_data_en'] = meta_data._sce(item['std_data_cn'],item['std_dataset_cn'])
        writer.writerows(items)




