#!/bin/bash

echo "开始尝试SSH连接"

output=$(sshpass -p 'password' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt username@panelX.serv00.com "ps -A; echo '登录成功'")

echo "$output"

if echo "$output" | grep -q "登录成功"; then
    login_result=1
else
    login_result=0
fi

echo "开始尝试推送"

python3 serv00.py "$login_result"