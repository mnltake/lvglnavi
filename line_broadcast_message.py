# -*- coding: utf-8 -*-

"""line_broadcast_message.py
    LINEグループMessageAPIでブロードキャストメッセージを送信します。
    https://developers.line.biz/ja/reference/messaging-api/#send-broadcast-message
"""

import requests
class LINEBroadcastBot:
    """LINEグループにブロードキャストメッセージを送信します。
    アクセストークンv2.1は以下から取得できます: https://developers.line.biz/ja/reference/messaging-api/#issue-channel-access-token-v2-1
    参考記事 https://qiita.com/jksoft/items/4d57a9282a56c38d0a9c

    Args:
        access_token (str):
            LINEメッセージAPIを利用するために必要なアクセストークン。

    Attributes:
        __headers (dict): LINEメッセージにリクエストを送信するために必要なヘッダー。
        API_URL (str): LINEメッセージAPIのURL。
    """
    API_URL = 'https://api.line.me/v2/bot/message/broadcast'
    
    def __init__(self, access_token):
        self.__headers = {
            'Authorization': 'Bearer ' + access_token,
            'Content-Type': 'application/json'
        }
        
    def send(self, message, massage1=None, massage2=None, massage3=None, massage4=None ):
        """指定されたアクセストークンでLINEグループにブロードキャストメッセージを送信します。

        Args:
            message (str): 送信メッセージ。最大長は5000文字です。
                Noneの場合、メッセージを送信できません。

        Returns:
            response (requests.models.Response): requests.postのレスポンス。
        """
        if not message:
            raise ValueError('メッセージはNoneであってはなりません。')
        if not isinstance(message, str):
            raise TypeError(f'メッセージはstrでなければなりません。しかし、入力されたメッセージの型は: {type(message)}')
        
        payload = {
            "messages": [
                {
                    "type": "text",
                    "text": message
                }
            ]
        }

        response = requests.post(
            LINEBroadcastBot.API_URL,
            headers=self.__headers,
            json=payload,
        )
        
        if not response.ok:
            print(response)
            raise Exception('メッセージを送信できません。理由を確認してください。')

        return response


if __name__ == '__main__':
    line_access_token = "YOUR_TOKEN"    
    bot = LINEBroadcastBot(access_token=line_access_token)
    bot.send(message=line_bot_message)
    # bot.send(message=line_bot_message, massage1='test', massage2='test', massage3='test', massage4='test')