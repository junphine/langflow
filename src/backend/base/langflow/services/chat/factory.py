from langflow.services.chat.service import ChatService
from langflow.services.factory import ServiceFactory


class ChatServiceFactory(ServiceFactory):
    def __init__(self) -> None:
        super().__init__(ChatService)

    def create(self,settings_service: "SettingsService"):
        # Here you would have logic to create and configure a ChatService
        return ChatService(settings_service)
