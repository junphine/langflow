from typing import Optional, cast

from langchain_community.chat_message_histories import FileChatMessageHistory
from langflow.base.memory.model import LCChatMemoryComponent
from langflow.field_typing.constants import Memory
from langflow.inputs import MessageTextInput, StrInput, IntInput
from langflow.field_typing import BaseChatMessageHistory
from langflow.schema import Data


class FileMemory(LCChatMemoryComponent):
    name = "FileMemory"
    display_name = "File Message ChatMemory"
    description = "Retrieves and stored chat messages from File."
    icon: str = "File"

    inputs = [
        StrInput(
            name="file_path",
            display_name="File Path",
            info="File Path",
            value="",
            required=True,
        ),
        StrInput(
            name="encoding",
            display_name="File Encoding",
            info="encoding write to default utf-8.",
            value="utf-8",
            advanced=True,
        ),
        IntInput(
            name="ttl",
            display_name="Message TTL",
            info="TTL can be represented by an integer or a Python timedelta  object",
            advanced=True,
        )
    ]

    def build_message_history(self) -> Memory:
        memory = FileChatMessageHistory(
            file_path=self.file_path,
            encoding=self.encoding or None,
            ensure_ascii=False,
        )
        return memory

