import csv
import requests
import json


PATH = r'C:/TEAM/贵州医药监管平台/'

URL = 'https://ggfwpz.ylbzj.cq.gov.cn/hsa-pss-pw/web/pw/terms/queryMedicalPage'


def read_std_codes(input_file):
    std_dataset = {}
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        reader = csv.DictReader(f)
        # 遍历文件中的每一行
        for row in reader:
            id = row['smat_inx']
            std_dataset[id] = row
    return std_dataset

def read_std_error_codes(input_file):
    std_dataset = {}
    with open(input_file, 'r',encoding='utf-8') as f:
        # 创建csv阅读器
        data = json.load(f)
        # 遍历文件中的每一行
        for id in data.keys():
            row = dict()
            std_dataset[id] = row
    return std_dataset

results = []
#input_ids = read_std_codes(PATH+'data-mat-codes.csv')
input_ids = read_std_error_codes(PATH+'mat_id_result_error.json')
errors_ids = {}
for id,input in input_ids.items():
    data = {
        "pageNum": 1,
        "pageSize": 1,
        "hiGenname":"",
        "medListCodg": id
    }
    # 将字典转换为 JSON 字符串
    json_data = json.dumps(data)

    # 设置请求头，指定内容类型为 JSON
    headers = {
        'Content-Type': 'application/json'
    }
    try:
        response = requests.post(URL,data=json_data,headers=headers)

        # 检查请求是否成功
        if response.status_code != 200:
            print(f"Failed to retrieve the page: {response.status_code}")
            errors_ids[id] = response.status_code
        else:
            data_result = json.loads(response.content)
            data_list = data_result['data']['data']
            if len(data_list)>0:
                data = data_list[0]
                input['id'] = id
                input['price'] = data['hilistPricUplmtAmt']
                input['level'] = data['chrgitmLv']
                input['prodentpCode'] = data['prodentpCode']
                results.append(input)
            else:
                errors_ids[id] = 404
    except Exception as e:
        errors_ids[id] = 500
        print(e)


with open(PATH+'mat_id_result.csv','w',encoding='utf-8',newline='') as fout:
    writer = csv.DictWriter(fout,results[0].keys())
    writer.writeheader()
    writer.writerows(results)



with open(PATH+'mat_id_result_error.json','w',encoding='utf-8') as fout:
    json.dump(errors_ids,fout,ensure_ascii=False)