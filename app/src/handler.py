import json
import logging
import os

APP_ENV = os.environ.get("APP_ENV", "local")
APP_VERSION = os.environ.get("APP_VERSION", "dev")

LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(LOG_LEVEL)

MOCK_SENSOR_DATA = [
    {"id": 1, "name": "C02 Sensor", "C02 Concentration": 612, "Unit": "ppm"},
    {"id": 2, "name": "Temperature Sensor", "Temperature": 22.5, "Unit": "C"},
]


def _response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }


def health(event):
    return _response(200, {"status": "ok", "env": APP_ENV, "version": APP_VERSION})


def list_sensor_data(event):
    return _response(200, {"sensordata": MOCK_SENSOR_DATA, "count": len(MOCK_SENSOR_DATA)})


ROUTES = {
    "GET /health": health,
    "GET /sensor-data": list_sensor_data,
}


def lambda_handler(event, context):
    route_key = event.get("routeKey", "")
    request_id = getattr(context, "aws_request_id", "local")

    logger.info(json.dumps({"route": route_key, "request_id": request_id, "env": APP_ENV}))

    route = ROUTES.get(route_key)
    if route is None:
        return _response(404, {"error": "not found"})
    
    try:
        return route(event)
    except Exception:
        logger.exception("unhandled error, request_id=%s", request_id)
        return _response(500, {"error": "internal server error"})