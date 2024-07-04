from typing import Dict, List, Optional, Type
from typing import List

from langflow.custom import CustomComponent
from langflow.schema import Data
from langflow.utils.util import unescape_string
from ohflow.interface.textsplitters.ChineseTextSplitter import ChineseTextSplitter


class ChineseTextSplitterComponent(CustomComponent):
    display_name = "ChineseTextSplitter"
    description = "Splitting text that looks at chinese characters."

    def build_config(self):
        return {
            "inputs": {"display_name": "Input", "input_types": ["Document", "Record"]},
            "chunk_overlap": {"display_name": "Chunk Overlap", "default": 200},
            "chunk_size": {"display_name": "Chunk Size", "default": 1000},
            "separator": {"display_name": "Separator", "default": "\n"},
        }

    def build(
            self,
            inputs: List[Data],
            chunk_overlap: int = 200,
            chunk_size: int = 1000,
            separator: str = "\n",
    ) -> List[Data]:
        # separator may come escaped from the frontend
        separator = unescape_string(separator)
        documents = []
        for _input in inputs:
            if isinstance(_input, Data):
                documents.append(_input.to_lc_document())
            else:
                documents.append(_input)
        docs = ChineseTextSplitter(
            chunk_overlap=chunk_overlap,
            chunk_size=chunk_size,
            separator=separator,
        ).split_documents(documents)
        records = self.to_data(docs)
        self.status = records
        return records
