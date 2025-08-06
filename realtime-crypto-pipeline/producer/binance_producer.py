import json
import websocket
from kafka import KafkaProducer

BINANCE_WS = "wss://stream.binance.com:9443/ws/btcusdt@trade"

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

def on_message(ws, message):
    data = json.loads(message)
    producer.send("raw_price", value=data)
    print(f"Sent: {data}")

def on_error(ws, error):
    print("Error:", error)

def on_close(ws, code, msg):
    print("Closed connection")

def on_open(ws):
    print("Connected to Binance WebSocket")

if __name__ == "__main__":
    ws = websocket.WebSocketApp(
        BINANCE_WS,
        on_message=on_message,
        on_error=on_error,
        on_close=on_close
    )
    ws.on_open = on_open
    ws.run_forever()