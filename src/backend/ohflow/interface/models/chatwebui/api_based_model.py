'''

This is an example on how to use the API for oobabooga/text-generation-webui.

Make sure to start the web UI with the following flags:

python server.py --model MODEL --listen --no-stream

Optionally, you can also add the --share flag to generate a public gradio URL,
allowing you to use the API remotely.

'''
import requests
import json

# Server address
server_addr = "http://172.16.29.92:5000/api/v1/generate"

# Generation parameters
# Reference: https://huggingface.co/docs/transformers/main_classes/text_generation#transformers.GenerationConfig
defulat_params = {
    'max_new_tokens': 250,
    'do_sample': True,
    'temperature': 1.3,
    'top_p': 0.1,
    'typical_p': 1,
    'repetition_penalty': 1.18,
    'top_k': 40,
    'min_length': 0,
    'no_repeat_ngram_size': 0,
    'num_beams': 1,
    'penalty_alpha': 0,
    'length_penalty': 1,
    'early_stopping': False,
    'seed': -1,
    'add_bos_token': True,
    'truncation_length': 4096,
    'ban_eos_token': False,
    'skip_special_tokens': True,
    'stopping_strings': []
}

class ApiBaseModel:
    def __init__(self):
        self.user_history = {} 
        
    def clear_history(self,name):
        if name in self.user_history:
            self.user_history[name] = []

    def __call__(self,prompt,params,stopping_strings=[]):
        # Input prompt
        ctx = "What I would like to say is the following: "
        use_params = defulat_params.copy()
        use_params.update(params)
        use_params['prompt'] = prompt

        response = requests.post(server_addr, json=use_params)

        if response.status_code == 200:
            result = response.json()['results'][0]
            print(str(result))
            reply = result['text']
            return reply
    
def model_handler():
    proxy = ApiBaseModel()
    return proxy

def tokenizer_handler():
    def encode(text,**kwargs):
        return text.split()
    return encode


