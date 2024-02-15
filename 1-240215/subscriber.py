import paho.mqtt.client as mqtt
import uuid
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

uuid = uuid.uuid4().__str__()
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_database = os.getenv("DB_DATABASE")
db_username = os.getenv("DB_USERNAME")
db_password = os.getenv("DB_PASSWORD")

def on_message(client, userdata, message):
  print(f"Received `{message.payload.decode()}` from `{message.topic}` topic")
  payload = message.payload.decode()
  cursor.execute('''INSERT INTO staging.messung(payload) VALUES (%s)''', (payload,))
  conn.commit()

conn = psycopg2.connect(host=db_host, port=db_port, database=db_database, user=db_username, password=db_password)
cursor = conn.cursor()

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, uuid, clean_session=False)
mqttc.on_message = on_message

mqttc.connect("broker.hivemq.com", 1883, 60)
mqttc.subscribe("DataMgmt", qos=1)

mqttc.loop_forever()