import json

import random
import sys
import os
import json
import os
import sys


import shutil
from tqdm import tqdm
import json

import random
import sys
import os
random.seed(123)
sys.path.append("../../src")
sys.path.append("/mnt/data/nlp/llm/CPM/")


PATH = r'C:/TEAM/贵州医药监管平台/'

verbalizer = {"0": "bad", "1": "great"}
dataset_name = "sst2"

# 初始化一些超参数以及verbalizer
lr = 4e-3
proto_dim = 128
model_logits_weight = 1
max_epochs = 100

import os, shutil
import time
import torch
from torch import nn
import torch.nn.functional as F
from tqdm import tqdm
import dill
import warnings
from typing import Optional
from typing import Callable, Union, Dict, List
try:
    from typing import OrderedDict
except ImportError:
    from collections import OrderedDict
from sklearn.metrics import accuracy_score
from copy import deepcopy

class DecTCPM(object):
    r"""A runner for DecT
    This class is specially implemented for classification.
    Decoder Tuning: Efficient Language Understanding as Decoding : https://arxiv.org/pdf/2212.08408.pdf

    Args:
        model (:obj:`CPMBeeTorch`): One ``CPMBeeTorch`` object.
        test_dataloader (:obj:`FinetuneDataset`): The dataloader to bachify and process the test data.
        tokenizer (:obj:`CPMBeeTokenizer`): The tokenizer to process the word.
        verbalizer (:obj:`Verbalizer`): The verbalizer to map the label to the word.
        device (:obj:`torch.device`): The device to run the model.
        calibrate_dataloader (:obj:`FinetuneDataset`, optional): The dataloader that has empty input, to modify the output logits. Defaults to None.
        lr (:obj:`float`, optional): The learning rate. Defaults to 5e-3.
        hidden_size (:obj:`int`, optional): The hidden size of the model. Defaults to 4096.
        mid_dim (:obj:`int`, optional): The dimension of the proto vector. Defaults to 128.
        epochs (:obj:`int`, optional): The number of epochs to train. Defaults to 5.
        model_logits_weight (:obj:`float`, optional): The weight of the model logits. Defaults to 1.
    """
    def __init__(self,
                 model,
                 test_dataloader,
                 val_dataloader,
                 tokenizer,
                 verbalizer,
                 device: Optional[Union[str, torch.device]] = "cuda:0",
                 calibrate_dataloader: Optional[List] = None,
                 lr: Optional[float] = 5e-3,
                 hidden_size: Optional[int] = 4096,
                 mid_dim: Optional[int] = 128,
                 epochs: Optional[int] = 5,
                 model_logits_weight: Optional[float] = 1,
                 ):
        self.model = model
        self.val_dataloader = val_dataloader
        self.test_dataloader = test_dataloader
        self.calibrate_dataloader = calibrate_dataloader
        self.loss_function = torch.nn.CrossEntropyLoss()
        self.device = device
        ids = []
        for idx in range(len(verbalizer.items())):
            ids.append(tokenizer.encode(verbalizer[str(idx)])[0][0])
        self.label_list = list(verbalizer.values())
        self.label_word_token_ids = []
        for label_word in self.label_list:
            self.label_word_token_ids.append(tokenizer.encode(label_word)[0][0])
        self.ids = ids #nn.Parameter(torch.tensor(ids), requires_grad=False)
        self.num_classes = len(self.ids)
        self.lr = lr
        self.mid_dim = mid_dim
        self.epochs = epochs
        self.model_logits_weight = model_logits_weight
        self.hidden_dims = hidden_size
        self.reset_parameter()

    # reset the parameters, useful when you want to test different random seeds
    # self.head is a linear layer, if you want to use other models, you can modify it (useful when there are more data)
    def reset_parameter(self):
        self.head = nn.Linear(self.hidden_dims, self.mid_dim, bias=False)
        w = torch.empty((self.num_classes, self.mid_dim)).to(self.device)
        nn.init.xavier_uniform_(w)
        self.proto = nn.Parameter(w, requires_grad=False)
        r = torch.ones(self.num_classes)
        self.proto_r = nn.Parameter(r, requires_grad=True)
        self.optimizer = torch.optim.Adam([p for n, p in self.head.named_parameters()] + [self.proto_r], lr=self.lr)


    # get the logits and hidden states of the model, specifically for cpmbee model, you can modify it for other models
    def get_logits_and_hidden(self,data):
        input_ids = torch.from_numpy(data["inputs"]).cuda().to(torch.int32)
        input_ids_sub = torch.from_numpy(data["inputs_sub"]).cuda().to(torch.int32)
        input_length = torch.from_numpy(data["length"]).cuda().to(torch.int32)
        input_context = torch.from_numpy(data["context"]).cuda().bool()
        input_sample_ids = torch.from_numpy(data["sample_ids"]).cuda().to(torch.int32)
        input_num_segments = torch.from_numpy(data["num_segments"]).cuda().to(torch.int32)
        input_segment_ids = torch.from_numpy(data["segment_ids"]).cuda().to(torch.int32)
        input_segment_rel_offset = (
            torch.from_numpy(data["segment_rel_offset"]).cuda().to(torch.int32)
        )
        input_segment_rel = torch.from_numpy(data["segment_rel"]).cuda().to(torch.int32)
        input_span = torch.from_numpy(data["spans"]).cuda().to(torch.int32)
        targets = torch.from_numpy(data["target"]).cuda().to(torch.int32)
        ext_table_ids = torch.from_numpy(data["ext_ids"]).cuda().to(torch.int32)
        ext_table_sub = torch.from_numpy(data["ext_sub"]).cuda().to(torch.int32)
        task_ids = torch.from_numpy(data["task_ids"]).cuda().to(torch.int32)
        task_names = data["task_names"]
        # to get the label from the targets
        mask = torch.logical_or(targets ==self.ids[0], targets==self.ids[1])
        labels = targets[mask]
        final_label = []
        for i in range(len(labels)):
            final_label.append(self.ids.index(labels[i]))
        with torch.no_grad():
            logits, hidden_states = self.model(
                input_ids,
                input_ids_sub,
                input_length,
                input_context,
                input_sample_ids,
                input_num_segments,
                input_segment_ids,
                input_segment_rel_offset,
                input_segment_rel,
                input_span,
                ext_table_ids,
                ext_table_sub,
            )
        # mask the targets where value is -100 or 7, to get the index of the valid position
        mask_matrix = deepcopy(targets)
        mask_matrix[targets == -100] = 0
        mask_matrix[targets == 7] = 0
        index_mask = mask_matrix.nonzero(as_tuple=False)
        # finally we get the logits and hidden states of the <ans> word position
        filtered_logits = logits[index_mask[:, 0], index_mask[:, 1], :]
        filtered_hiddens = hidden_states[index_mask[:, 0], index_mask[:, 1], :]
        label_logits = filtered_logits[:,self.label_word_token_ids] # F.softmax(filtered_logits)[:,self.label_word_token_ids]
        return label_logits, filtered_hiddens,final_label

    # test the model on the dev set, if zs is true, then test on the zero-shot setting, otherwise test on the decoder tuning setting
    def test(self, dataloader,zs):
        if zs:
            preds = []
            labels = []
            for iteration, data in enumerate(dataloader):
                if data is None:
                    if last_data is None:
                        raise RuntimeError(
                            "Dataset is too small, please use a smaller batch size or sequence length!"
                        )
                    data = last_data  # use last data
                    skip_this_batch = True
                else:
                    last_data = data
                logits,_,label = self.get_logits_and_hidden(data)
                preds.extend(torch.argmax(logits, dim=-1).cpu().tolist())
                labels.extend(label)
            res = sum([int(i==j) for i,j in zip(preds, labels)])/len(preds)
            return res
        else:
            preds = []
            labels = []
            for iteration, data in enumerate(dataloader):
                if data is None:
                    if last_data is None:
                        raise RuntimeError(
                            "Dataset is too small, please use a smaller batch size or sequence length!"
                        )
                    data = last_data  # use last data
                    skip_this_batch = True
                else:
                    last_data = data
                logits,hidden_states,label = self.get_logits_and_hidden(data)
                proto_logits = self.sim(self.head(hidden_states.float()), self.proto, self.proto_r, logits.float(), self.model_logits_weight).cpu()
                preds.extend(torch.argmax(proto_logits, dim=-1).cpu().tolist())
                labels.extend(label)
            res = sum([int(i==j) for i,j in zip(preds, labels)])/len(preds)
            return res

    @staticmethod
    def sim(x, y, r=0, model_logits=0, model_logits_weight=1):
        x = torch.unsqueeze(x, -2)
        x = F.normalize(x, dim=-1)
        d = torch.norm((x - y), dim=-1)
        dist = d - model_logits * model_logits_weight - r
        return -dist

    # conduct the loss function in the decoder tuning
    def loss_func(self, x, model_logits, labels):
        sim_mat = torch.exp(self.sim(x, self.proto, self.proto_r, model_logits, self.model_logits_weight))
        pos_score = torch.sum(sim_mat * F.one_hot(labels), -1)
        loss = -torch.mean(torch.log(pos_score / sim_mat.sum(-1)))
        return loss

    # run zero shot setting
    def run_zs(self):
        res = self.test(self.test_dataloader, zs = True)
        print("zero shot acc:",res)

    # train the model with decoder tuning, you need to provide the training dataloader (type:FinetuneDataset)
    def run(self, train_dataloader):
        logits_list = []
        hidden_states_list = []
        labels = []
        with torch.no_grad():
            for iteration, data in enumerate(train_dataloader):
                if data is None:
                    if last_data is None:
                        raise RuntimeError(
                            "Dataset is too small, please use a smaller batch size or sequence length!"
                        )
                    data = last_data  # use last data
                    skip_this_batch = True
                else:
                    last_data = data
                train_logits, train_embeds,label = self.get_logits_and_hidden(data)
                logits_list.append(train_logits)
                hidden_states_list.append(train_embeds)
                labels.extend(label)
        train_logits = torch.cat(logits_list,dim=0)
        train_embeds = torch.cat(hidden_states_list,dim=0)
        embeds = [[] for _ in range(self.num_classes)]
        train_labels = [[] for _ in range(self.num_classes)]
        model_logits = [[] for _ in range(self.num_classes)]
        total_num = 0
        start_time = time.time()

        for idx, label in enumerate(labels):
            label = torch.tensor(label)
            train_labels[label].append(label)
            embeds[label].append(torch.tensor(train_embeds[idx]))
            model_logits[label].append(torch.tensor(train_logits[idx]))
        embeds = list(map(torch.stack, embeds))
        labels = torch.cat(list(map(torch.stack, train_labels))).to(self.device)
        model_logits = torch.cat(list(map(torch.stack, model_logits))).float()

        self.head.to(self.device)
        self.proto.to(self.device)
        self.proto_r.to(self.device)
        dist = list(map(lambda x: torch.norm(self.head(x.float()) - self.head(x.float().mean(0)), dim=-1).mean(), embeds))
        self.proto_r.data = torch.stack(dist)

        loss = 0.
        best_eval_res = 0.

        for epoch in range(self.epochs):
            x = self.head(torch.cat(embeds).float())
            self.optimizer.zero_grad()
            loss = self.loss_func(x, model_logits, labels)
            loss.backward()
            self.optimizer.step()
            # use vaild dataset to evaluate the model, and test on best_eval_res
            if epoch % 20 == 0 and epoch > 0 :
                print("Total epoch: {}. DecT loss: {}".format(epoch, loss))
                eval_res = self.test(self.val_dataloader, zs = False)
                print("val acc:", eval_res)
                if eval_res > best_eval_res:
                    best_eval_res = eval_res
                    test_res = self.test(self.test_dataloader, zs = False)
                    print("test acc at best val:",test_res)


        end_time = time.time()
        print("Total time: {}".format(end_time - start_time))
        res= self.test(self.test_dataloader, zs = False)
        print("Final acc:",res)

from cpm_live.tokenizers import CPMBeeTokenizer
from cpm_live.training_tasks.bee import FinetuneDataset
from cpm_live.models import CPMBeeConfig, CPMBeeTorch
import torch
import torch.nn.functional as F
from copy import deepcopy
model_path = '/data/nlp/models/OpenBMB/cpm-bee-10b/'
config = CPMBeeConfig.from_json_file(model_path+"config.json")
ckpt_path = model_path+"/pytorch_model.bin"

tokenizer = CPMBeeTokenizer()
model = CPMBeeTorch(config=config)
model.load_state_dict(torch.load(ckpt_path), strict=True)
device = torch.device("cuda:0")
model.to(device)

train_dataloader = FinetuneDataset(
    dataset_path = "./decoder_tuning_data//bin_data/{}/train_data".format(dataset_name),
    batch_size=8,
    max_length=512,
    max_depth=8,
    tokenizer=tokenizer,
)
val_dataloader = FinetuneDataset(
    dataset_path = "./decoder_tuning_data/bin_data/{}/valid_data".format(dataset_name),
    batch_size=8,
    max_length=512,
    max_depth=8,
    tokenizer=tokenizer,
)
test_dataloader = FinetuneDataset(
    dataset_path = "./decoder_tuning_data/bin_data/{}/test_data".format(dataset_name),
    batch_size=8,
    max_length=512,
    max_depth=8,
    tokenizer=tokenizer,
)

runner = DecTCPM(
    model = model,
    test_dataloader = test_dataloader,
    val_dataloader=val_dataloader,
    tokenizer = tokenizer,
    verbalizer = verbalizer,
    device = device,
    calibrate_dataloader = None,
    lr = lr,
    mid_dim = proto_dim,
    epochs = max_epochs,
    model_logits_weight = model_logits_weight,
)

runner.run_zs()
runner.run(train_dataloader)


self = runner
for iteration, data in enumerate(test_dataloader):
    logits,hidden_states,label = self.get_logits_and_hidden(data)
    proto_logits = self.sim(self.head(hidden_states.float()), self.proto, self.proto_r, logits.float(), self.model_logits_weight).cpu()
    pred = torch.argmax(proto_logits, dim=-1).cpu().tolist()
    print(pred)
