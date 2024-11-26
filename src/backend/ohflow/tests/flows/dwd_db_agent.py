
from langflow.load import run_flow_from_json
from pathlib import Path
from dotenv import load_dotenv
# 获取当前执行文件的绝对路径
current_file_path = Path(__file__).resolve()

# 获取当前执行文件的目录
current_directory = current_file_path.parent

print("当前执行文件的目录:", current_directory)

load_dotenv('.env')

TWEAKS = {
    "DeepseekLLM-psNqL": {},
    "ChatInput-eJtsc": {},
    "TextInput-GmcDE": {},
    "Prompt-wztHN": {},
    "IgniteDatabase-CLhhm": {},
    "DremioSQLAgent-m6gQ1": {},
    "ChatOutput-TfiLo": {},
    "Prompt-4juhI": {},
    "TextOutput-ZDukc": {}
}

result = run_flow_from_json(flow= current_directory / "_Database Agent 医疗健康数据智能检索 .json",
                            input_value="出院结算费用中医保支付的费用总和",
                            user_id="b531f147-4c73-4913-bbd2-71abacdfe311",
                            session_id="", # provide a session id if you want to use session state
                            fallback_to_env_vars=True, # False by default
                            tweaks=TWEAKS)

print(result)