import os.path
from argparse import ArgumentParser

import torch

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("--use-bminf", default=False, action="store_true", help="Whether to use BMInf")
    parser.add_argument("--memory-limit", type=int, default=20, help="GPU Memory limit, in GB")
    parser.add_argument("--model-path", default='/data/nlp/models/OpenBMB/cpm-bee-10b/', type=str, help="The path to load.")
    parser.add_argument("--delta", default=None, type=str, help="The path to lora.")
    parser.add_argument("--device", default="cuda:0", type=str, help="The target device.")
    args = parser.parse_args()
    return args


def load_beam_search(args):

    model_path = args.model_path

    config = CPMBeeConfig.from_json_file('config/cpm-bee-10b.json')
    ckpt_path = model_path+"/pytorch_model.bin"

    tokenizer = CPMBeeTokenizer()
    model = CPMBeeTorch(config=config)

    if args.delta is not None:
        from opendelta import LoraModel
        delta_model = LoraModel(backbone_model=model, modified_modules=["project_q", "project_v"], backend="hf")
        model.load_state_dict(torch.load(args.delta), strict=False)

    if os.path.exists(ckpt_path):
        model.load_state_dict(torch.load(ckpt_path), strict=False)
    else:
        model.init_parameters()

    if args.device == "cpu":
        model = model.float()
    else:
        if not torch.cuda.is_available():
            raise AssertionError("The CUDA is unavailable")
        if args.use_bminf:
            import bminf
            with torch.cuda.device(args.device):
                model = bminf.wrapper(model, quantization=False, memory_limit=args.memory_limit << 30)
        model.cuda(args.device)

    # use beam search
    beam_search = CPMBeeBeamSearch(
        model=model,
        tokenizer=tokenizer,
    )

    return beam_search


def main():
    args = parse_args()

    data_list = [
        {"document": "今天<mask_0>,天气是真的<mask_1>","prompt":"在document里面续写一段话", "<ans>": {"<mask_0>": "","<mask_1>": ""}},
        {"input": "狂风暴雨，今天天气是真的","prompt":"续写一段话", "<ans>": ""},
    ]

    # use beam search
    beam_search = load_beam_search(args)
    inference_results = beam_search.generate(data_list, max_length=100, repetition_penalty=1.1)
    for res in inference_results:
        print(res)

if __name__ == "__main__":
    main()
