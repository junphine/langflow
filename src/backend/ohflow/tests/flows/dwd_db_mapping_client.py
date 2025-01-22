import argparse
import json
from argparse import RawTextHelpFormatter
import requests
from typing import Optional
import warnings
try:
    from langflow.load import upload_file
except ImportError:
    warnings.warn("Langflow provides a function to help you upload files to the flow. Please install langflow to use it.")
    upload_file = None

BASE_API_URL = "http://localhost:3003"
FLOW_ID = "7c0341f3-a712-4092-a19c-e79c3d3a73eb"
ENDPOINT = "auto_mapping" # The endpoint name of the flow


#FLOW_ID = "12ab7722-d553-4c34-8eb4-887d30d259a6"
#ENDPOINT = "auto_mapping_small" # The endpoint name of the flow


# You can tweak the flow by adding a tweaks dictionary
# e.g {"OpenAI-XXXXX": {"model_name": "gpt-4"}}
TWEAKS = {
    "Prompt-7b2Ep": {},
    "DeepseekLLM-Vessh": {},
    "TextOutput-ikGYp": {},
    "TableMappingAgent-YVV5T": {},
    "SQLDatabase-KSWp1": {},
    "ChatInput-g5tyX": {},
    "ChatOutput-COnbb": {}
}
PATH = r'C:/TEAM/贵州医药监管平台/'


def run_flow(message: str,
             endpoint: str,
             output_type: str = "chat",
             input_type: str = "chat",
             tweaks: Optional[dict] = None,
             api_key: Optional[str] = None) -> dict:
    """
    Run a flow with a given message and optional tweaks.

    :param message: The message to send to the flow
    :param endpoint: The ID or the endpoint name of the flow
    :param tweaks: Optional tweaks to customize the flow
    :return: The JSON response from the flow
    """
    api_url = f"{BASE_API_URL}/api/v1/run/{endpoint}"

    payload = {
        "input_value": message,
        "output_type": output_type,
        "input_type": input_type,
    }
    headers = None
    if tweaks:
        payload["tweaks"] = tweaks
    if api_key:
        headers = {"x-api-key": api_key}
    response = requests.post(api_url, json=payload, headers=headers)
    return response.json()

def main(args,input_value):
    try:
        tweaks = json.loads(args.tweaks)
    except json.JSONDecodeError:
        raise ValueError("Invalid tweaks JSON string")

    if args.upload_file:
        if not upload_file:
            raise ImportError("Langflow is not installed. Please install it to use the upload_file function.")
        elif not args.components:
            raise ValueError("You need to provide the components to upload the file to.")
        tweaks = upload_file(file_path=args.upload_file, host=BASE_API_URL, flow_id=args.endpoint, components=[args.components], tweaks=tweaks)


    response = run_flow(
        message=input_value,
        endpoint=args.endpoint,
        output_type=args.output_type,
        input_type=args.input_type,
        tweaks=tweaks,
        api_key=args.api_key
    )
    try:
        outputs = response.get("outputs", [])[0].get("outputs", [])
        message = outputs[0].get("results", {}).get("message")
        print(json.dumps(message, indent=2))
        return message
    except Exception as e:
        print(e)
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""Run a flow with a given message and optional tweaks.
Run it like: python <your file>.py "your message here" --endpoint "your_endpoint" --tweaks '{"key": "value"}'""",
                                     formatter_class=RawTextHelpFormatter)

    parser.add_argument("--endpoint", type=str, default=ENDPOINT or FLOW_ID, help="The ID or the endpoint name of the flow")
    parser.add_argument("--tweaks", type=str, help="JSON string representing the tweaks to customize the flow", default=json.dumps(TWEAKS))
    parser.add_argument("--api_key", type=str, help="API key for authentication", default='sk-TkGBzFgzgSrDPYQysAYPEgAR7v_iYh9Xq4MeaNuA--U')
    parser.add_argument("--output_type", type=str, default="chat", help="The output type")
    parser.add_argument("--input_type", type=str, default="chat", help="The input type")
    parser.add_argument("--upload_file", type=str, help="Path to the file to upload", default=None)
    parser.add_argument("--components", type=str, help="Components to upload the file to", default=None)
    args = parser.parse_args()

    std_result_dataset = {}
    std_result_new_dataset = {}
    with open(PATH + 'std_result.json','r',encoding='utf-8') as fd:
        std_result_dataset = json.load(fd)

    for ods_table,row2 in std_result_dataset.items():
        m_std_tables:list = row2['std_table']
        input_str = ods_table # +'->'+ ','.join(m_std_tables)
        msg = main(args,input_str)
        if msg is not None:
            text = msg.get('text')
            result = json.loads(text)
            std_result_new_dataset[ods_table] = result

    with open(PATH+ENDPOINT+'_result.json','w',encoding='utf-8') as fd:
        json.dump(std_result_new_dataset,fd,indent=4,ensure_ascii=False)