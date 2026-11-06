import json
import os

APP_ENV = os.environ.get("APP_ENV", "local")
APP_VERSION = os.environ.get("APP_VERSION", "dev")


def lambda_handler(event, context):
    body = {"status": "ok", "env": APP_ENV, "version": APP_VERSION}
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }