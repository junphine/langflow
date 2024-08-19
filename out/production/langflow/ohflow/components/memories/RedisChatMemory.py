from typing import Optional, cast

from langchain_community.chat_message_histories import RedisChatMessageHistory
from langflow.base.memory.model import LCChatMemoryComponent
from langflow.inputs import MessageTextInput, StrInput, IntInput
from langflow.field_typing import BaseChatMessageHistory
from langflow.schema import Data


class RedisChatMemory(LCChatMemoryComponent):
    name = "RedisChatMemory"
    display_name = "Redis DB Message ChatMemory"
    description = "Retrieves and stored chat messages from Redis DB."
    icon: str = "Redis"

    inputs = [
        StrInput(
            name="connection_string",
            display_name="Mongo DB Endpoint",
            info="API endpoint URL for the Redis DB service,such as: redis://localhost:6379/0",
            value="REDIS_ENDPOINT",
            required=True,
        ),
        StrInput(
            name="key_prefix",
            display_name="Key Prefix Name",
            info="The prefix of the collection within Redis DB where the vectors will be stored.",
            advanced=True,
        ),
        IntInput(
            name="ttl",
            display_name="Message TTL",
            info="TTL can be represented by an integer or a Python timedelta  object",
            advanced=True,
        ),
        MessageTextInput(
            name="session_id", display_name="Session ID", info="Session ID for the message.", advanced=True
        ),
    ]

    def build_message_history(self) -> BaseChatMessageHistory:

        memory = RedisChatMessageHistory(
            url=self.connection_string,
            session_id=self.session_id,
            key_prefix=self.key_prefix or None,
            ttl=self.ttl,
        )
        return memory

