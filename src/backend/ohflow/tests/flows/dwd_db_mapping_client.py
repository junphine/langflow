import argparse
import json,time
from argparse import RawTextHelpFormatter
import requests
import collections
import csv
from typing import Optional
import warnings
try:
    from langflow.load import upload_file
except ImportError:
    warnings.warn("Langflow provides a function to help you upload files to the flow. Please install langflow to use it.")
    upload_file = None

BASE_API_URL = "http://localhost:7860"

ENDPOINT = "auto_mapping_ignite"

ENDPOINT = "auto_mapping_ignite_xiangtan"

ENDPOINT = "auto_mapping_ignite_shanxi"

#ENDPOINT = "auto_mapping_kimi" # The endpoint name of the flow

#ENDPOINT = "auto_mapping_small" # The endpoint name of the flow

#import ohflow.tests.table_mapping.stds.std_tables_data_xiangtan as meta_data
#import ohflow.tests.table_mapping.stds.std_tables_data_qingdao as meta_data
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
PATH = r'C:/TEAM/湘潭项目仁医部分/'
#PATH = r'C:/TEAM/青岛-七医新/'
PATH = r'C:/TEAM/三秦/'

std_result_new_dataset = {}

def read_std_csv_tables(input_file):
    std_dataset = collections.OrderedDict()
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            row['TABLE_NAME'] = row['TABLE_NAME'].upper()
            id = row['TABLE_NAME']
            std_dataset[id] = row

    return std_dataset

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


def main_run_flow(args,tweaks,input_value):
    try:
        response = run_flow(
            message=input_value,
            endpoint=args.endpoint,
            output_type=args.output_type,
            input_type=args.input_type,
            tweaks=tweaks,
            api_key=args.api_key
        )
        outputs = response.get("outputs", [])[0].get("outputs", [])
        message = outputs[0].get("results", {}).get("message")
        print(json.dumps(message, indent=2))
        time.sleep(1)
        return message

    except Exception as e:
        print(e)
        with open(PATH+ENDPOINT+'_result.json','w',encoding='utf-8') as fd:
            json.dump(std_result_new_dataset,fd,indent=4,ensure_ascii=False)

        if 'JSONDecodeError' not in str(e.__class__.__name__):
            time.sleep(5*60)
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""Run a flow with a given message and optional tweaks.
Run it like: python <your file>.py "your message here" --endpoint "your_endpoint" --tweaks '{"key": "value"}'""",
                                     formatter_class=RawTextHelpFormatter)

    parser.add_argument("--endpoint", type=str, default=ENDPOINT, help="The ID or the endpoint name of the flow")
    parser.add_argument("--tweaks", type=str, help="JSON string representing the tweaks to customize the flow", default=json.dumps(TWEAKS))
    parser.add_argument("--api_key", type=str, help="API key for authentication", default='sk-TkGBzFgzgSrDPYQysAYPEgAR7v_iYh9Xq4MeaNuA--U')
    parser.add_argument("--output_type", type=str, default="chat", help="The output type")
    parser.add_argument("--input_type", type=str, default="chat", help="The input type")
    parser.add_argument("--upload_file", type=str, help="Path to the file to upload", default=None)
    parser.add_argument("--components", type=str, help="Components to upload the file to", default=None)
    args = parser.parse_args()

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


    std_result_dataset = {}

    """
    with open(PATH + 'std_result.json','r',encoding='utf-8') as fd:
        std_result_dataset = json.load(fd)
    """

    std_result_dataset = read_std_csv_tables(PATH+'公卫5.0表列表.csv')

    for table_name, src_table in std_result_dataset.items():
        input_str = src_table['TABLE_SCHEMA']+'.'+table_name.upper()
        if not input_str:
            continue
        msg = main_run_flow(args,tweaks,input_str)
        if msg is not None:
            text = msg.get('text')
            try:
                result = json.loads(text)
                std_result_new_dataset[table_name] = result
            except Exception as e:
                print(e)
                print(text)
                std_result_new_dataset[table_name] = text

    with open(PATH+ENDPOINT+'_result.json','w',encoding='utf-8') as fd:
        json.dump(std_result_new_dataset,fd,indent=4,ensure_ascii=False)