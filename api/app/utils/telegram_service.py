import requests
from app.config import (
    TELEGRAM_API_BASE_URL,
    TELEGRAM_API_CHAT_ID,
    TELEGRAM_API_PARSE_MODE_MARKDOWN,
)


def telegram_send_message(chat_ids, message):
    success_responses = []
    failure_responses = []

    for chat_id in chat_ids:
        api_url = f"{TELEGRAM_API_BASE_URL}{TELEGRAM_API_CHAT_ID}{chat_id}{TELEGRAM_API_PARSE_MODE_MARKDOWN}{message}"
        response = requests.get(api_url)
        response_json = response.json()

        if response_json.get("ok"):
            success_responses.append(
                {
                    "chat_id": chat_id,
                    "message": f"Message sent successfully to chat ID {chat_id}.",
                }
            )
        else:
            failure_responses.append(
                {
                    "chat_id": chat_id,
                    "message": f"Failed to send message to chat ID {chat_id}.",
                }
            )

    return {
        "success_responses": success_responses,
        "failure_responses": failure_responses,
    }
