from typing import Optional, cast

from langchain_community.chat_message_histories import MongoDBChatMessageHistory
from langflow.base.memory.model import LCChatMemoryComponent
from langflow.inputs import MessageTextInput, StrInput, BoolInput
from langflow.field_typing import BaseChatMessageHistory
from langflow.schema import Data


class MongoDBChatMemory(LCChatMemoryComponent):
    name = "MongoDBChatMemory"
    display_name = "Mongo DB Message ChatMemory"
    description = "Retrieves and stored chat messages from Mongo DB."
    icon: str = "MongoDB"

    inputs = [
        StrInput(
            name="connection_string",
            display_name="Mongo DB Endpoint",
            info="API endpoint URL for the Mongo DB service.",
            value="MONGO_DB_API_ENDPOINT",
            required=True,
        ),
        StrInput(
            name="database_name",
            display_name="Database Name",
            info="Database namespace within Mongo DB to use for the collection.",
            required=True,
        ),
        StrInput(
            name="collection_name",
            display_name="Collection Name",
            info="The name of the collection within Mongo DB where the vectors will be stored.",
            advanced=True,
        ),
        BoolInput(
            name="create_index",
            display_name="Astra DB Application Token",
            info="Whether to create an index with name SessionId.",
            advanced=True,
        ),
        MessageTextInput(
            name="session_id", display_name="Session ID", info="Session ID for the message.", advanced=True
        ),
    ]

    def build_message_history(self) -> BaseChatMessageHistory:

        memory = MongoDBChatMessageHistory(
            connection_string=self.connection_string,
            session_id=self.session_id,
            collection_name=self.collection_name or None,
            create_index=self.create_index,
            database_name=self.database_name or None,
        )
        return memory

