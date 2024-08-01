import sys
from os import path
from datetime import datetime

message = ""


def load_send():
    cur_path = path.abspath(path.dirname(__file__))
    if path.exists(cur_path + "/notify.py"):
        try:
            from notify import send

            return send
        except ImportError:
            return False
    else:
        return False


def main():
    result = int(sys.argv[1])
    now = datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if result == 1:
        message = f"serv00登录成功\n登陆时间：{current_time}"
    else:
        message = "serv00登录失败"
    send = load_send()
    if callable(send):
        send("serv00", message)
    else:
        print("\n加载通知服务失败")


if __name__ == "__main__":
    main()
