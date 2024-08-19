from typing import Dict, List, Optional, Type
from langchain_core.embeddings import Embeddings
from langflow.custom import CustomComponent
from ohflow.interface.embeddings import RawTextEmbeddings


class RawTextEmbeddingsComponent(CustomComponent):
    name = "RawTextEmbeddings"
    display_name: str = "Raw Text Embeddings"
    description: str = "Generate embeddings using ignite serverside api models."
    documentation = "https://python.langchain.com/docs/integrations/text_embedding/ollama"

    def build_config(self):
        return {
            "model": {
                "display_name": "Text Embeddings Model",
            },
            "mongodb_url": {"display_name": "MongoDb Base URL"},
            "collection": {"display_name": "MongoDb collection to store doc"},
            "code": {"show": False},
        }

    def build(
            self,
            model: str = "moe-base",
            mongodb_url: str = "mongodb://localhost:27017",
            collection: str = "text_embedding",
    ) -> Embeddings:
        try:
            output = RawTextEmbeddings(model=model,mongodb_url=mongodb_url,collection=collection)  # type: ignore
        except Exception as e:
            raise ValueError("Could not connect to Ignite Embedding API.") from e
        return output

