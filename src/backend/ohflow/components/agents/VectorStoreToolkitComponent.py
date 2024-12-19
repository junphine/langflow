from typing import Union

from langchain.agents.agent_toolkits.vectorstore.toolkit import VectorStoreInfo, VectorStoreToolkit

from langflow.custom import CustomComponent
from langflow.field_typing import LanguageModel, Tool
from langflow.inputs import MessageTextInput, MultilineInput, HandleInput
from langflow.template import Output


class VectorStoreToolkitComponent(CustomComponent):
    name = "VectorStoreToolkit"
    display_name = "VectorStoreToolkit"
    description = "Toolkit for interacting with a Vector Store."
    legacy: bool = True

    inputs = [
        MessageTextInput(
            name="vectorstore_name",
            display_name="Name",
            info="Name of the VectorStore",
            required=True,
        ),
        MultilineInput(
            name="vectorstore_description",
            display_name="Description",
            info="Description of the VectorStore",
            required=True,
        ),
        HandleInput(
            name="input_vectorstore",
            display_name="Vector Store",
            input_types=["VectorStore"],
            required=True,
        ),
        HandleInput(
            name="llm",
            display_name="Language Model",
            input_types=["LanguageModel"],
            required=True,
        ),
    ]

    outputs = [
        Output(display_name="Vector Store Info", name="info", method="build_info"),
        Output(display_name="Vector Store Toolkit", name="toolkit", method="build_toolkit"),
    ]

    def build_info(self) -> VectorStoreInfo:
        self.status = {
            "name": self.vectorstore_name,
            "description": self.vectorstore_description,
        }
        return VectorStoreInfo(
            vectorstore=self.input_vectorstore,
            description=self.vectorstore_description,
            name=self.vectorstore_name,
        )

    def build_toolkit(self) -> Union[Tool, VectorStoreToolkit]:
        return VectorStoreToolkit(vectorstore_info=self.build_info(), llm=self.llm)
