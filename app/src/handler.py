import json
import os

APP_ENV = os.environ.get("APP_ENV", "local")
APP_VERSION = os.environ.get("APP_VERSION", "dev")

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
    route = ROUTES.get(route_key)
    if route is None:
        return _response(404, {"error": "not found"})
    return route(event)