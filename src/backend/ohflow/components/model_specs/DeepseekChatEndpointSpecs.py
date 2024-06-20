from typing import Optional
from urllib.parse import urlparse
from langchain_openai import ChatOpenAI
from pydantic.v1 import SecretStr


from langflow.custom import CustomComponent
from langflow.field_typing import BaseLanguageModel, NestedDict


class DeepseekChatEndpointComponent(CustomComponent):
    display_name: str = "DeepseekChatEndpoint"
    description: str = (
        "Deepseek chat models. Get more detail from "
        "https://chat.deepseek.com/."
    )
    icon = "OpenAI"

    DEEPSEEK_MODELS = [
        "deepseek-chat",
        "deepseek-coder",
    ]

    def build_config(self):
        return {
            "max_tokens": {
                "display_name": "Max Tokens",
                "advanced": True,
                "info": "The maximum number of tokens to generate. Set to 0 for unlimited tokens.",
            },
            "model_kwargs": {
                "display_name": "Model Kwargs",
                "advanced": True,
                "required": False,
            },
            "model_name": {"display_name": "Model Name", "advanced": False, "options": self.DEEPSEEK_MODELS},
            "openai_api_base": {
                "display_name": "OpenAI API Base",
                "advanced": True,
                "required": False,
                "info": (
                    "The base URL of the OpenAI API. Defaults to https://api.openai.com/v1.\n\n"
                    "You can change this to use other APIs like JinaChat, LocalAI and Prem."
                ),
            },
            "openai_api_key": {
                "display_name": "OpenAI API Key",
                "advanced": False,
                "required": False,
                "password": True,
            },
            "temperature": {
                "display_name": "Temperature",
                "advanced": False,
                "required": False,
                "value": 0.7,
            },
        }

    def build(
            self,
            max_tokens: Optional[int] = 0,
            model_kwargs: NestedDict = {},
            model_name: str = "deepseek-chat",
            openai_api_base: Optional[str] = None,
            openai_api_key: Optional[str] = None,
            temperature: float = 0.7,
    ) -> BaseLanguageModel:
        if not openai_api_base:
            openai_api_base = "https://api.deepseek.com"
        if openai_api_key:
            api_key = SecretStr(openai_api_key)
        else:
            api_key = None
        return ChatOpenAI(
            max_tokens=max_tokens or None,
            model_kwargs=model_kwargs,
            model=model_name,
            base_url=openai_api_base,
            api_key=api_key,
            temperature=temperature,
        )

