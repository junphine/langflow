from typing import Dict, List, Optional, Type
from langchain_core.embeddings import Embeddings
from langflow.custom import CustomComponent
from ohflow.interface.embeddings import RawTextEmbeddings


class RawTextEmbeddingsComponent(CustomComponent):
    display_name: str = "Raw Text Embeddings"
    description: str = "Generate embeddings using ignite api models."
    documentation = "https://python.langchain.com/docs/integrations/text_embedding/ollama"

    def build_config(self):
        return {
            "model": {
                "display_name": "Text Embeddings Model",
            },
            "base_url": {"display_name": "Ignite Base URL"},
            "temperature": {"display_name": "Model Temperature"},
            "code": {"show": False},
        }

    def build(
            self,
            model: str = "moe-base",
            base_url: str = "mongodb://localhost:27017",
            temperature: Optional[float] = None,
    ) -> Embeddings:
        try:
            output = RawTextEmbeddings()  # type: ignore
        except Exception as e:
            raise ValueError("Could not connect to Ignite Embedding API.") from e
        return output

