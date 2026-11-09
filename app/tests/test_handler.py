import json

import handler


class FakeContext:
    aws_request_id = "test-request-id"


def call(route_key):
    result = handler.lambda_handler({"routeKey": route_key}, FakeContext())
    return result["statusCode"], json.loads(result["body"])


def test_health_returns_ok():
    status, body = call("GET /health")
    assert status == 200
    assert body["status"] == "ok"


def test_sensor_data_returns_readings():
    status, body = call("GET /sensor-data")
    assert status == 200
    assert body["count"] == len(body["sensordata"]) > 0
    for reading in body["sensordata"]:
        assert {"id", "name", "type", "value", "unit"} <= reading.keys()


def test_unknown_route_returns_404():
    status, body = call("GET /hallam")
    assert status == 404


def test_crash_returns_500_without_leaking_details(monkeypatch):
    def broken(event):
        raise RuntimeError("secret internal detail")

    monkeypatch.setitem(handler.ROUTES, "GET /health", broken)
    status, body = call("GET /health")
    assert status == 500
    assert "secret" not in json.dumps(body)