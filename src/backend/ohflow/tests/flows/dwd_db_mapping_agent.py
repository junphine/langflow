from langflow.load import run_flow_from_json,load_flow_from_json
from pathlib import Path
from dotenv import load_dotenv
import asyncio
from asyncio import WindowsSelectorEventLoopPolicy

from langflow.processing.process import run_graph
from langflow.utils.async_helpers import run_until_complete

asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())

# 获取当前执行文件的绝对路径
current_file_path = Path(__file__).resolve()

# 获取当前执行文件的目录
current_directory = current_file_path.parent

print("当前执行文件的目录:", current_directory)

load_dotenv('.env')

import ohflow.interface.agents.std_tables_data as meta_data

TWEAKS = {
    "Prompt-7b2Ep": {},
    "DeepseekLLM-Vessh": {},
    "TextOutput-ikGYp": {},
    "TableMappingAgent-YVV5T": {},
    "SQLDatabase-KSWp1": {},
    "ChatOutput-aMAXw": {},
    "ChatInput-g5tyX": {}
}
# add@byron
input_value="门(急)诊挂号表.就诊次数"

result = run_flow_from_json(flow=current_directory /"_Database重庆医疗数据智能映射.json",
                            input_value=input_value,
                            user_id="b531f147-4c73-4913-bbd2-71abacdfe311",
                            session_id="test", # provide a session id if you want to use session state
                            fallback_to_env_vars=True, # False by default
                            tweaks=TWEAKS)

graph = load_flow_from_json(flow=current_directory / "_Database重庆医疗数据智能映射.json",
                            user_id="b531f147-4c73-4913-bbd2-71abacdfe311",
                            tweaks=TWEAKS)

graph.session_id = "test"

core = run_graph(
    graph=graph,
    session_id="test",
    input_value=input_value,
    input_type = "chat",
    output_type = "chat",
    fallback_to_env_vars=True,
)

result = run_until_complete(core)
print(result)


