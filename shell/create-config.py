m-- coding:UTF-8 --
import uuid
import yaml
import sys
import os

# code_server_pwd = str(uuid.uuid4())
code_server_pwd = os.getenv("PAI_CONTAINER_ID")

print("======================================================================================")
print("WEBIDE PASSWORD:" + code_server_pwd)
print("======================================================================================")

sys.stderr.write("======================================================================================")
sys.stderr.write("WEBIDE PASSWORD:" + code_server_pwd)
sys.stderr.write("======================================================================================")

with open('/root/.config/code-server/config.yaml', 'r', encoding='utf-8') as fi:
    content = yaml.load(fi, Loader=yaml.FullLoader)
    content["password"] = code_server_pwd
    content["bind-addr"] = "0.0.0.0:" + os.getenv("PAI_CONTAINER_HOST_codeserver_PORT_LIST")
    print(content)
    with open('/root/.config/code-server/config.yaml', mode = 'w', encoding='utf-8') as fo:
        content1 = yaml.dump(content)
        fo.write(content1)

