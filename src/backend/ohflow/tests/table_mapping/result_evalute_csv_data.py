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



header = 'ods_dataset_cn,ods_data_cn,std_dataset_cn,std_data_cn,humans,humans_data_cn'.split(',')

PATH = r'C:/TEAM/贵州医药监管平台/'


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
from ohflow.interface.agents.std_tables_data import *
# key:ods_table,value:list[dict(std_data_name,ods_data_name)]
std_matched_dict = collections.defaultdict(list)
std_matched_error_dict = collections.defaultdict(list)
if std_result_dataset:
    for ods_table,row2 in std_result_dataset.items():
        m_std_tables:list = row2['std_table']
        for field,m_fields in row2.items():
            if field=='std_table':
                continue
            m_fields.sort(key=lambda x: x[0])
            if m_fields==[]:
                for m_std_table in m_std_tables:
                    match_id = ods_table+'.'+field + ':'+ m_std_table
                    if match_id in matched_ods_field_table_dict:
                        humans_data_cn = matched_ods_field_table_dict[match_id]
                        item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn=m_std_table,std_data_cn="",humans_data_cn=humans_data_cn)
                        std_matched_dict[ods_table].append(item)
                        fn+=1
            i=0
            for m_pos_field in m_fields:
                m_field = m_pos_field[1]
                std_table,std_field = m_field.split('.')
                if i>0 and ('费' in std_field or '姓名' in std_field or '时间' in std_field or '地址' in std_field):
                    break
                item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn=std_table,std_data_cn=std_field,humans=0)
                match_id = std_table+'.'+std_field+':'+ods_table+'.'+field
                match2_id = std_field+':'+field
                if match_id in matched_dict or match2_id in matched_field_dict:
                    item["humans"] = 1
                    tp+=1
                else:
                    match_id = ods_table+'.'+field + ':'+ std_table
                    if match_id in matched_ods_field_table_dict:
                        fp+=1
                        item["humans_data_cn"] = matched_ods_field_table_dict[match_id]
                    else:
                        inc+=1
                    std_matched_error_dict[ods_table].append(item)
                std_matched_dict[ods_table].append(item)
                i+=1

        c+=1


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
        writer.writerows(items)

with open(PATH+ENDPOINT+'_ods_predict_error_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,header)
    writer.writeheader()
    for items in std_matched_error_dict.values():
        writer.writerows(items)




