import yaml
import psutil
import torch

with open('impala.yaml', 'r', encoding='utf-8') as fi:
    content = yaml.load(fi, Loader=yaml.FullLoader)
    content["impala-benchmark"]["config"]["num_workers"] = psutil.cpu_count() - 1
    content["impala-benchmark"]["config"]["num_gpus"] = torch.cuda.device_count()
    content["impala-benchmark"]["config"]["object_store_memory"] = 50*1024**3
    print(content)
    with open('impala-dynamic.yaml', 'w', encoding='utf-8') as fo:
        content1 = yaml.dump(content)
        fo.write(content1)
