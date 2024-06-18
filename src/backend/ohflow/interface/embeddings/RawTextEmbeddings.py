from typing import Dict, List, Optional, Type
from langchain.schema.embeddings import Embeddings
from pydantic import BaseModel


class RawTextEmbeddings(Embeddings, BaseModel):
    size: int = 768

    @staticmethod
    def function_name():
        return "Return Raw Text instead Embeddings,for ServerSide Embedding"

    def _get_embedding(self,text):
        return text

    def embed_documents(self, texts: List[str]) -> List[List[float]]:
        return [self._get_embedding(text) for text in texts]

    def embed_query(self, text: str) -> List[float]:
        return self._get_embedding(text)