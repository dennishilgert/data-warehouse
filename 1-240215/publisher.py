import paho.mqtt.client as mqtt
import json, time, uuid, random

uuid = uuid.uuid4().__str__()
mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, uuid, clean_session=False)
mqttc.connect("broker.hivemq.com", 1883, 60)

class Auto:
    def __init__(self, fin, zeit, geschwindigkeit):
        self.fin = fin
        self.zeit = zeit
        self.geschwindigkeit = geschwindigkeit

auto_daten = Auto("TXUZRMM9032150DSJ", 0, 0)

while True:
    auto_daten.zeit = int(time.time())
    auto_daten.geschwindigkeit = random.randint(0, 50)
    mqttc.publish("DataMgmt", json.dumps(auto_daten.__dict__), qos=1)
    time.sleep(5)