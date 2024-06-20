import asyncio
import threading
from collections import defaultdict
from typing import Any, Optional

from langflow.services.base import Service
from langflow.services.cache import ThreadingInMemoryCache, AsyncInMemoryCache
from langflow.services.deps import get_cache_service


class ChatService(Service):
    name = "chat_service"

    def __init__(self,settings_service=None):
        self.cache_service = get_cache_service()
        if isinstance(self.cache_service, ThreadingInMemoryCache):
            self.cache_service = AsyncInMemoryCache()

        self._cache_locks = defaultdict(asyncio.Lock)

    async def set_cache(self, key: str, data: Any, lock: Optional[asyncio.Lock] = None) -> bool:
        """
        Set the cache for a client.
        """
        # client_id is the flow id but that already exists in the cache
        # so we need to change it to something else
        result_dict = {
            "result": data,
            "type": type(data),
        }
        res = self.cache_service.upsert(key, result_dict, lock=lock or self._cache_locks[key])
        if res is not None and hasattr(res, '__await__'):
            res = await res
        return key in self.cache_service

    async def get_cache(self, key: str, lock: Optional[asyncio.Lock] = None) -> Any:
        """
        Get the cache for a client.
        """
        res = self.cache_service.get(key, lock=lock or self._cache_locks[key])
        if res is not None and hasattr(res, '__await__'):
            res = await res
        return res

    async def clear_cache(self, key: str, lock: Optional[asyncio.Lock] = None):
        """
        Clear the cache for a client.
        """
        res = self.cache_service.delete(key, lock=lock or self._cache_locks[key])
        if res is not None and hasattr(res, '__await__'):
            res = await res
        return res
