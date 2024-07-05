import json
from typing import Any, Callable, Dict, Type

from langchain.schema.embeddings import Embeddings
from langchain.vectorstores import (
    Pinecone,
    #Qdrant,
    Chroma,
    FAISS,
    Weaviate,
    SupabaseVectorStore,
    MongoDBAtlasVectorSearch,
)

import os




def docs_in_params(params: dict) -> bool:
    """Check if params has documents OR texts and one of them is not an empty list,
    If any of them is not an empty list, return True, else return False"""
    return ("documents" in params and params["documents"]) or (
        "texts" in params and params["texts"]
    )


def initialize_mongodb(class_object: Type[MongoDBAtlasVectorSearch], params: dict):
    """Initialize mongodb and return the class object """

    MONGODB_ATLAS_CLUSTER_URI = params.pop("mongodb_atlas_cluster_uri")
    if not MONGODB_ATLAS_CLUSTER_URI:
        raise ValueError("Mongodb atlas cluster uri must be provided in the params")
    from pymongo import MongoClient
    import certifi

    client: MongoClient = MongoClient(
        MONGODB_ATLAS_CLUSTER_URI, tlsCAFile=certifi.where()
    )
    db_name = params.pop("db_name", None)
    collection_name = params.pop("collection_name", None)
    if not db_name or not collection_name:
        raise ValueError("db_name and collection_name must be provided in the params")

    index_name = params.pop("index_name", None)
    if not index_name:
        raise ValueError("index_name must be provided in the params")

    collection = client[db_name][collection_name]
    if not docs_in_params(params):
        # __init__ requires collection, embedding and index_name
        init_args = {
            "collection": collection,
            "index_name": index_name,
            "embedding": params.get("embedding"),
        }

        return class_object(**init_args)

    if "texts" in params:
        params["documents"] = params.pop("texts")

    params["collection"] = collection
    params["index_name"] = index_name

    return class_object.from_documents(**params)




def initialize_faiss(class_object: Type[FAISS], params: dict):
    """Initialize faiss and return the class object"""

    if not docs_in_params(params):
        return class_object.load_local

    save_local = params.get("save_local")
    faiss_index = class_object(**params)
    if save_local:
        faiss_index.save_local(folder_path=save_local)
    return faiss_index



def initialize_chroma(class_object: Type[Chroma], params: dict):
    """Initialize a ChromaDB object from the params"""
    persist = params.pop("persist", False)
    if not docs_in_params(params):
        params.pop("documents", None)
        params.pop("texts", None)
        params["embedding_function"] = params.pop("embedding")
        chromadb = class_object(**params)
    else:
        if "texts" in params:
            params["documents"] = params.pop("texts")
        for doc in params["documents"]:
            if doc.metadata is None:
                doc.metadata = {}
            for key, value in doc.metadata.items():
                if value is None:
                    doc.metadata[key] = ""
        chromadb = class_object.from_documents(**params)
    if persist:
        chromadb.persist()
    return chromadb


def initialize_qdrant(class_object, params: dict):

    if not docs_in_params(params):
        if "location" not in params and "api_key" not in params:
            raise ValueError("Location and API key must be provided in the params")
        from qdrant_client import QdrantClient

        client_params = {
            "location": params.pop("location"),
            "api_key": params.pop("api_key"),
        }
        lc_params = {
            "collection_name": params.pop("collection_name"),
            "embeddings": params.pop("embedding"),
        }
        client = QdrantClient(**client_params)

        return class_object(client=client, **lc_params)

    return class_object.from_documents(**params)


vecstore_initializer: Dict[str, Callable[[Type[Any], dict], Any]] = {
    "Chroma": initialize_chroma,
    "Qdrant": initialize_qdrant,
    "FAISS": initialize_faiss,
    "MongoDBAtlasVectorSearch": initialize_mongodb,
}

import numpy as np
from pydantic import BaseModel
from typing import List

from pymongo import MongoClient
from langchain.vectorstores import Qdrant
from langchain.vectorstores import MongoDBAtlasVectorSearch

from langchain.embeddings import HuggingFaceEmbeddings

HUB_MODELS_ROOT = 'C:\\Code\\huggingface\\hub-models\\'
# hugeface models
init_embedding_model = "m3e-base"
#init_embedding_model = "default"


# model config
embedding_model_dict = {
    "ernie-tiny": "nghuyong/ernie-3.0-nano-zh",
    "ernie-base": "nghuyong/ernie-3.0-base-zh",
    "ernie-medium": "nghuyong/ernie-3.0-medium-zh",
    "ernie-xbase": "nghuyong/ernie-3.0-xbase-zh",
    "text2vec-large": "shibing624/text2vec-large-chinese",
    "text2vec-base": "shibing624/text2vec-base-chinese",
    "m3e-base": "shibing624/m3e-base",
    'simbert-base-chinese': 'WangZeJun/simbert-base-chinese',
    'paraphrase-multilingual-MiniLM-L12-v2': "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2",
    'default':'sentence-transformers/all-mpnet-base-v2'
}

model_name = HUB_MODELS_ROOT+embedding_model_dict[init_embedding_model]
model_kwargs = {'device': 'cpu'}
encode_kwargs = {'normalize_embeddings': False}
"""
embedding_function = HuggingFaceEmbeddings(
    model_name=model_name,
    model_kwargs=model_kwargs,
    encode_kwargs=encode_kwargs
)
"""






class RawTextEmbeddings(Embeddings, BaseModel):
    size: int = 768

    def _get_embedding(self,text):
        return text

    def embed_documents(self, texts: List[str]) -> List[List[float]]:
        return [self._get_embedding(text) for text in texts]

    def embed_query(self, text: str) -> List[float]:
        return self._get_embedding(text)

def demo_qdrant():
    from qdrant_client import QdrantClient
    from qdrant_client.http.models import VectorParams
    host = 'https://fdd8f862-0bf1-4dcf-a35c-f809deb8b179.us-east-1-0.aws.cloud.qdrant.io:6333'
    api_key = 'c_qJgCP6qprsSJfrnYrsgVuSdHh8aiZiIFT4RZ6SskncvRRlvd6MEw'

    #client = QdrantClient(url=host,api_key=api_key)

    client = QdrantClient(path="qdrant.db")
    collection_name = "MyCollection5"

    param = VectorParams(size=768,distance='Cosine')
    client.create_collection(collection_name,param)

    qdrant = Qdrant(client, collection_name, embedding_function)

    qdrant.add_texts(['中国的首都','日本的首都','西安','南京','日本海','蒙古大草原'])

    result = qdrant.similarity_search_with_score('北京')

    result = qdrant.similarity_search_with_score('东京')

    vecstorer = vecstore_initializer['Qdrant']


    vecstore = vecstorer(Qdrant,params=dict(location=host,api_key=api_key,collection_name=collection_name,embeddings=embedding_function))

    result = vecstore.similarity_search('北京')

    result = vecstore.similarity_search('东京')


def demo_mongo():
    dbname = 'graph'
    mongo_client = MongoClient("mongodb://172.16.29.84:2701/"+dbname)

    collection_name = 'text_embedding_huge'
    collection = mongo_client[dbname][collection_name]
    collection.create_index([('text','text')])
    collection.create_index([('embedding','knnVector')])
    #embeddings = embedding_function
    #vectorstore = MongoDBAtlasVectorSearch(collection, embeddings)

    #vectorstore.add_texts(['中国的首都','日本的首都','西安','南京','日本海','蒙古大草原','北京','东京'])

    #result = vectorstore.similarity_search_with_score('北京',k=4)

    #result = vectorstore.similarity_search_with_score('东京',k=4)


    collection_name = 'text_embedding'
    collection = mongo_client[dbname][collection_name]
    collection.create_index([('text','text')])
    collection.create_index([('embedding','knnVector')])
    embeddings = RawTextEmbeddings(size=768)
    vectorstore = MongoDBAtlasVectorSearch(collection, embeddings)

    vectorstore.add_texts(['中国的首都','日本的首都','西安','南京','日本海','蒙古大草原','北京','东京'])

    result = vectorstore.similarity_search_with_score('北京',k=4)

    result = vectorstore.similarity_search_with_score('东京',k=4)

    print(result)


#demo_qdrant()
demo_mongo()