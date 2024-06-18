import json
import uuid

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
    WebSocket,
    WebSocketException,
    status,
)
from fastapi.responses import StreamingResponse
from langflow.api.utils import build_input_keys_response, Dictate
from langflow import load_flow_from_json

from loguru import logger
from langflow.services.deps import get_cache_service, get_chat_service, get_session
from sqlmodel import Session
from langflow.api.utils import build_input_keys_response, format_elapsed_time
from langflow.api.v1.schemas import BuildStatus, BuiltResponse, InitResponse, StreamData
from langflow.graph.graph.base import Graph
from langflow.services.auth.utils import (
    get_current_active_user,
    get_current_user_for_websocket,
    get_user_by_id
)
from langflow.services.cache.service import BaseCacheService
from langflow.services.cache.utils import update_build_status
from langflow.services.chat.service import ChatService

from . import api_based_model as chat_api
ernie_model = chat_api.model_handler()

router = APIRouter(tags=["Chat"])



@router.post("/chat", response_model=dict, status_code=201)
def chat(*,
        flow: dict,
        session: Session = Depends(get_session),
        token: str = Query(...),
        db: Session = Depends(get_session),
        chat_service: "ChatService" = Depends(get_chat_service),
):
    """Websocket endpoint for chat."""
    try:
        user = get_user_by_id(db, token)
        #user = await get_current_user(token, db)
        if not user:
            raise HTTPException(status_code=404, detail="Unauthorized")
        if not user.is_active:
            raise HTTPException(status_code=404, detail="Unauthorized")

        document = {}
        document['小说名'] = '《'+flow['name']+'》'
        document['故事概要'] = flow['description'].strip()
        ch_prompt = "\n|角色名|性别|年龄|人物介绍|\n"
        characters = flow['characters']
        for character in characters:
            ch_prompt += f"|\t{character['name']}\t|\t{character['gender']}\t|\t{character['age']}\t|\t{character['introduction']}\t|\n"

        document['人物列表'] = ch_prompt

        states = flow['states']

        document['剧情里面的涉及的状态变量以及其值'] = json.dumps(states,ensure_ascii=False)

        texts = ''
        for item in flow['data']:
            if 'text' in item:
                texts+=str(item['text'])
                texts+='\n'
            if 'children' in item:
                for citem in item['children']:
                    if 'text' in citem:
                        texts+=str(citem['text'])
                        texts+='\n'
        document['document'] = texts
        document['question'] = '现在请一步一步的基于document的内容，来续写小说,最多600字,每次只需要输出一次或多次角色对话对话，不需要续写完整的故事。格式一般为:“该角色的对话” 角色说。'
        document['<ans>'] = ''

        prompt = '你是一名优秀的作家，正在创作小说'+document['小说名']+'\n'
        prompt += '这篇小说主要讲述了:' + document['故事概要']+'\n'
        prompt += '这篇小说的主要角色表:' + document['人物列表']+"\n"

        prompt += '小说剧情里面的涉及的状态变量以及其值为：'+json.dumps(states,ensure_ascii=False);

        prompt += '\n现在请一步一步的基于下面的文本，来续写小说,最多600字,每次只需要输出一次或多次角色对话对话，不需要续写完整的故事。格式一般为:“该角色的对话” 角色说。\n\n'

        prompt += texts

        resp_flow = Dictate({})
        reply = '......'
        reply = ernie_model(prompt,{})
        resp_flow.name = flow['name']
        resp_flow.author = '' # 提问者
        resp_flow.data = [['<user>',reply]]
        resp_flow.uuid = user.id
        return resp_flow.as_dict()

    except Exception as exc:
        logger.error(f"Error in chat websocket: {exc}")
        messsage = exc.detail if isinstance(exc, HTTPException) else str(exc)
        raise HTTPException(status_code=500, detail=messsage)


@router.post("/character_chat", response_model=dict, status_code=201)
def character_chat(character, text):
    TWEAKS = {
        "SeriesCharacterChain-VwNaE": {},
        "ChatOpenAI-h7XEZ": {}
    }
    flow = load_flow_from_json("Series Character.json", tweaks=TWEAKS)
    # Now you can use it like any chain
    inputs = {"input":text}

    return flow(inputs)
