
# 填充API Key与Secret Key
import requests
import json

app_id='38554226'
api_key='ghravljfesy0bSBsSzFsh0vr'
api_secret='0GGiysLIliu4p7WOYdm35C2hBB5jKLE2'
gpt_url = "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/eb-instant"

class ApiBaseModel:
    def __init__(self,app_id, api_key, api_secret, gpt_url):
        self.user_history = {}
        self.app_id = app_id
        self.api_key = api_key
        self.api_secret = api_secret
        self.gpt_url = gpt_url
        self.access_token = None

    def get_access_token(self):
        if self.access_token is None:
            url = f"https://aip.baidubce.com/oauth/2.0/token?client_id={self.api_key}&client_secret={self.api_secret}&grant_type=client_credentials"

            payload = json.dumps("")
            headers = {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }

            response = requests.request("POST", url, headers=headers, data=payload)
            self.access_token = response.json().get("access_token")

        return self.access_token

    def clear_history(self,name):
        if name in self.user_history:
            self.user_history[name] = []

    def __call__(self, prompt, params, stopping_strings=[]):
        # Input prompt
        url = self.gpt_url+"?access_token=" + self.get_access_token()
        request = {
            "temperature": params.get('temperature',0.75),
            "top_p": params.get('top_p',0.75),
            "messages": [
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        }
        payload = json.dumps(request)
        headers = {
            'Content-Type': 'application/json'
        }

        response = requests.request("POST", url, headers=headers, data=payload)
        resp = json.loads(response.text)
        if 'error_msg' in resp:
            return resp['error_msg']
        return resp['result']


def model_handler():
    proxy = ApiBaseModel(app_id=app_id,
                         api_key=api_key,
                         api_secret=api_secret,
                         gpt_url=gpt_url)
    return proxy


def tokenizer_handler():
    def encode(text,**kwargs):
        return text.split()
    return encode


def gen(question):
    model = model_handler()
    g_reply = model(question,{})
    return g_reply


if __name__ == '__main__':

    prompt = """请按照以下模板逻辑完成answer后面的结果补全：
    input: this picture says 三.  question: which number the picture says? answer: [3]
    input: this picture says 五.  question: which number the picture says? answer: [5]
    input: this picture says 九.  question: which number the picture says? answer: """

    r = gen(prompt)
    print(r)

    prompt = """请按照以下模板逻辑完成answer后面的结果补全：
    input: this picture says 三.  question: which number the picture says? answer: [3]
    input: this picture says 五.  question: which number the picture says? answer: [5]
    input: this picture says 九.  question: which number the picture says? answer: """

    r = gen(prompt)
    print(r)