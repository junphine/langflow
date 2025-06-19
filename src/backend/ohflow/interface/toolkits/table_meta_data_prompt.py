import copy
import json
import re
import random
import os
import collections
from typing import Optional

from langchain_community.utilities import SQLDatabase
from langchain_core.tools import BaseToolkit

from ohflow.interface.toolkits.table_meta_data_tookits import DremioMetaDataToolkit


class MetaDataMappingPrompt:

    def __init__(self, source_db_toolkit: Optional[DremioMetaDataToolkit],target_db_toolkit: Optional[DremioMetaDataToolkit],use_field_desc=False):
        self.source_db = source_db_toolkit.db
        self.target_db = target_db_toolkit.db
        self.source_table_meta_data = source_db_toolkit.table_meta_data()
        self.target_table_meta_data = target_db_toolkit.table_meta_data()
        self.use_field_desc = use_field_desc
        self.source_table_comments = {}
        self.target_table_comments = {}
        self.table_mapping_prompt = self.init_table_mapping_prompt()

    def std_tables(self):
        return self.target_db.get_usable_table_names()

    def ods_tables(self):
        return self.source_db.get_usable_table_names()

    def init_table_mapping_prompt(self):
        # 构建提示词模板： tables
        tables = self.target_db.get_usable_table_dict()
        table_mapping_prompt = '## 标准库\n标准库中定义了如下表：\n| 表名 | 表注释 |\n'
        for name,table in tables.items():
            if self.target_table_meta_data:
                if name.upper() not in self.target_table_meta_data:
                    continue
            table_mapping_prompt += f'| {name} | {table.comment} |\n'
            self.target_table_comments[name.upper()] = table.comment

        tables = self.source_db.get_usable_table_dict()
        for name,table in tables.items():
            self.source_table_comments[name.upper()] = table.comment

        return table_mapping_prompt

    def table_doc_prompt(self,ods_table:str):
        external_table_mapping_prompt = ''
        if self.source_table_meta_data:
            tbl_info = self.source_table_meta_data.get(ods_table.upper())
            if tbl_info:
                if 'info' in tbl_info:
                    comment =  tbl_info.get('info',{}).get('TABLE_COMMENT')
                    if comment:
                        external_table_mapping_prompt+=f'**{ods_table}**:{comment}\n'
                if 'fields' in tbl_info:
                    for fname,field in tbl_info.get('fields',{}).items():
                        comment = field.get('TABLE_COMMENT')
                        if comment:
                            external_table_mapping_prompt+=f'**{ods_table}**:{comment}\n'
                        break
        if external_table_mapping_prompt:
            return '### 该表的厂商资料\n'+external_table_mapping_prompt
        return external_table_mapping_prompt

    def columns_doc_prompt(self,ods_table:str):
        external_table_mapping_prompt = ''
        if self.source_table_meta_data:
            tbl_info = self.source_table_meta_data.get(ods_table.upper())
            if tbl_info:
                if 'info' in tbl_info:
                    comment =  tbl_info.get('info',{}).get('TABLE_COMMENT')
                    if comment:
                        external_table_mapping_prompt+=f'**{ods_table}**:{comment}\n'
                if 'fields' in tbl_info:
                    for fname,field in tbl_info.get('fields',{}).items():
                        comment = field.get('COLUMN_COMMENT')
                        if comment:
                            external_table_mapping_prompt+=f'- {fname}:{comment}\n'
        if external_table_mapping_prompt:
            return '### 该表的厂商资料\n'+external_table_mapping_prompt
        return external_table_mapping_prompt

    # 返回询问ods_table的提示词
    def table_mapping_question(self,ods_table:str):
        input_str = ods_table
        input_str = self.source_db.get_table_info_no_throw([ods_table])
        input_str = input_str[40:]
        external_table_mapping_prompt = self.table_doc_prompt(ods_table)
        prompt = self.table_mapping_prompt+ f'\n\n## 业务表\n{input_str}\n{external_table_mapping_prompt}\n## 开始表映射任务\n从标准库中选出可以与业务表相映射的表，只需要返回表名,表注释，不需要返回其他信息。\n'
        return dict(prompt=prompt)

    def fields_mapping_question(self,ods_table:str|list,std_table:str|list):
        input_table = ods_table
        if isinstance(ods_table,str):
            input_table = [ods_table]
        ods_table_mapping_prompt = self.source_db.get_table_info_no_throw(input_table)
        ods_table_mapping_prompt = ods_table_mapping_prompt[40:]

        external_table_mapping_prompt = self.columns_doc_prompt(ods_table)

        if isinstance(std_table,str):
            std_table = [std_table]
        std_table_mapping_prompt = self.target_db.get_table_info_no_throw(std_table)

        prompt = f'## 标准表\n{std_table_mapping_prompt}\n## 业务表\n{ods_table_mapping_prompt}\n{external_table_mapping_prompt}\n##开始字段映射任务\n从所给标准表中选出与业务表"{ods_table}"的各个字段可以映射的字段，若无匹配字段，则跳过。使用表格格式返回，表格包含列（业务表字段名，业务表字段的中文注释，标准表名，标准字段名，标准字段的中文注释）。\n'
        return dict(prompt=prompt)

