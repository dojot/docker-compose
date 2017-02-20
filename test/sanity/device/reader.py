import os
import time
import paho.mqtt.client as mqtt

broker=os.environ['MQTT']
print "will connect to %s" % (broker)
try:
	device=os.environ['DEVICE']
except KeyError as e:
	device="dummy"

# mqtt init
client = mqtt.Client()
client.connect(broker, 1883, 60)
client.loop_start()

it=0
while True:
	print("About to send temp: %f " % (it))
	client.publish("/device/%s/attrs" % device, "{ \"temperature\": %f }" % (it))
	it+=1
	time.sleep(1.0)
