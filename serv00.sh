#!/bin/bash

json_file="accounts.json"
login_results=()

temp_file=$(mktemp)
jq -c '.accounts[]' "$json_file" > "$temp_file"

total_accounts=$(jq '.accounts | length' "$json_file")
echo "共找到${total_accounts}个账号"

count=1

while IFS= read -r account; do
    username=$(echo "$account" | jq -r '.username')
    password=$(echo "$account" | jq -r '.password')
    panel=$(echo "$account" | jq -r '.panel')

    echo "开始执行第${count}个账号"
    echo "用户: $username, 登陆面板: $panel"

    output=$(timeout 30 sshpass -p "$password" ssh -n -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt "$username@$panel" "ps -A; echo '登录成功'" 2>&1)

    if echo "$output" | grep -q "登录成功"; then
        login_result=1
        echo "${username}登陆成功"
    else
        login_result=0
        echo "${username}登陆失败，请检查用户名和密码是否正确"
    fi

    login_results+=("$username:$panel:$login_result")

    sleep 3

    count=$((count + 1))
done < "$temp_file"

rm "$temp_file"

echo "所有账号执行完毕"
echo "开始尝试推送"
python3 serv00.py "${login_results[@]}"