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

from ohflow.tests.table_mapping.stds.build_embedding_index import *
import ohflow.tests.table_mapping.stds.std_tables_data_qingdao as meta_data
#import ohflow.interface.agents.std_tables_data_xiangtan as meta_data
ENDPOINT = "auto_mapping_ignite" # The endpoint name of the flow

"""
生成匹配结果：

"""



header = 'ods_dataset_cn,ods_dataset_en,ods_data_cn,ods_data_en,std_dataset_cn,std_dataset_en,std_data_cn,std_data_en,humans,humans_data'.split(',')

PATH = r'C:/TEAM/湘潭项目仁医部分/'
PATH = r'C:/TEAM/青岛-七医新/'
ods_dataset = meta_data.ods_dataset

tp=3
tn=0 #实际为负类的样本被正确地分类为负类的数量。
fp=1 #实际为负类的样本被错误地分类为正类的数量
fn=3 #实际为正类的样本被错误地分类为负类的数量
inc=0
c=1
std_result_dataset = {}
with open(PATH+ENDPOINT+'_result.json','r',encoding='utf-8') as fd:
    std_result_dataset = json.load(fd)

# 遍历标化模型，生成匹配结果

matched_target_field_dict = meta_data.matched_target_field_dict
# key:ods_table,value:list[dict(std_data_name,ods_data_name)]
std_matched_dict = collections.defaultdict(list)
std_matched_error_dict = collections.defaultdict(list)
if std_result_dataset:
    """
    for ods_table,row2 in std_result_dataset.items():
        if isinstance(row2,str):
            continue
        m_std_tables:list = row2['std_table']
        for field,m_fields in row2.items():
            if field=='std_table':
                continue
            ods_table_dict = ods_tables[ods_table]
            field_en = ods_table_dict['fields'][field]['data_name_en']
            m_fields.sort(key=lambda x: x[0])
            if m_fields==[]:
                for m_std_table in m_std_tables:
                    std_table_dict = std_tables[m_std_table]
                    match_id = ods_table_dict['dataset_name_en']+'.'+field_en + ':'+ std_table_dict['dataset_name_en']
                    if match_id in matched_ods_field_table_dict:
                        humans_data_cn = matched_ods_field_table_dict[match_id]
                        item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn=m_std_table,std_data_cn="",humans_data_cn=humans_data_cn)
                        std_matched_dict[ods_table].append(item)
                        fn+=1
            i=0
            for m_pos_field in m_fields[0:3]:
                m_field = m_pos_field[1]
                std_table,std_field = m_field.split('.',1)
                if i>0 and ('费' in std_field or '姓名' in std_field or '时间' in std_field or '地址' in std_field):
                    break
                std_table_dict = std_tables[std_table]
                std_field_en = std_table_dict['fields'][std_field]['data_name_en']
                item = dict(ods_dataset_cn=ods_table,ods_data_cn=field,std_dataset_cn=std_table,std_data_cn=std_field,humans=0)
                match_id = std_table_dict['dataset_name_en']+'.'+std_field_en+':'+ods_table_dict['dataset_name_en']+'.'+field_en
                match2_id = std_field_en+':'+field_en
                if match_id in matched_dict or match2_id in matched_field_dict:
                    item["humans"] = 1
                    tp+=1
                else:
                    match_id = ods_table_dict['dataset_name_en']+'.'+field_en + ':'+ std_table_dict['dataset_name_en']
                    if match_id in matched_ods_field_table_dict:
                        fp+=1
                        item["humans_data_cn"] = matched_ods_field_table_dict[match_id]
                    else:
                        inc+=1
                    std_matched_error_dict[ods_table].append(item)
                std_matched_dict[ods_table].append(item)
                i+=1
    """
    for ods_table,row2 in std_result_dataset.items():
        if isinstance(row2,str):
            continue
        m_std_tables:dict = row2['std_table']
        ods_table_cn = row2['comment']
        target_columns = row2['columns']
        for m_field in target_columns:
            t_table_en = m_field['标准表名']
            t_table_cn = m_std_tables.get(t_table_en.upper(),"")
            t_column_en = m_field['标准字段名']
            t_column_cn = m_field['标准字段的中文注释']
            t_id = (t_table_en+'.'+t_column_en).lower()

            ods_column_en = m_field['业务表字段名'].upper()
            ods_column_cn = m_field['业务表字段的中文注释']
            if t_column_en=='' or t_table_en=='-':
                for match_id,table_filed in matched_target_field_dict.items():
                    if ods_column_en == table_filed[1] and ods_table in table_filed[0]:
                        item = dict(ods_dataset_en=ods_table,ods_data_cn=ods_column_cn,std_dataset_en=t_table_en,std_dataset_cn=t_table_cn,std_data_en=t_column_en,std_data_cn="",humans_data=match_id)
                        std_matched_dict[ods_table].append(item)
                        fn+=1

            else:
                check = False
                item = dict(ods_dataset_en=ods_table,ods_data_cn=ods_column_cn,std_dataset_en=t_table_en,std_dataset_cn=t_table_cn,std_data_en=t_column_en,std_data_cn=t_column_cn,humans=0)
                for match_id,table_filed in matched_target_field_dict.items():
                    if t_id==match_id:
                        check = True
                        if ods_column_en in table_filed[1]:
                            item = dict(ods_dataset_cn=ods_table,ods_data_cn=ods_column_cn,std_dataset_en=t_table_en,std_dataset_cn=t_table_cn,std_data_cn="",humans=0,humans_data=match_id)
                            std_matched_dict[ods_table].append(item)
                            item["humans"] = 1
                            tp+=1
                        elif ods_table in table_filed[0]:
                            fp+=1
                            item["humans_data"] = match_id
                            std_matched_error_dict[ods_table].append(item)

                if False and not check:
                    if t_column_cn==ods_column_cn or (t_column_cn in ods_column_cn and len(t_column_cn)>1):
                        tp+=1
                    else:
                        inc+=1
                    std_matched_dict[ods_table].append(item)
            c+=1


#fn = len(matched_dict)-tp
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
            pass
        writer.writerows(items)

with open(PATH+ENDPOINT+'_ods_predict_error_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,header)
    writer.writeheader()
    for items in std_matched_error_dict.values():
        writer.writerows(items)




