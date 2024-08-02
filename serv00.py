import sys
from os import path


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


def main(login_results):
    global message
    for result in login_results:
        username, panel, login_result = result.split(":")
        login_result = int(login_result)

        if login_result == 1:
            message += f"用户：{username} 登录面板：{panel} 成功\n"
        else:
            message += f"用户：{username} 登录面板：{panel} 失败\n"

    send = load_send()
    if callable(send):
        send("serv00&ct8", message)
    else:
        print("\n加载通知服务失败")


if __name__ == "__main__":
    login_results = sys.argv[1:]
    main(login_results)
