extends Node

var websocket = WebSocketClient.new()

func _ready():
	websocket.connect("connection_closed", self, "connectionClosed")
	websocket.connect("connection_error", self, "connectionClosed")
	websocket.connect("connection_established", self, "connectionEstablished")
	websocket.connect("data_received", self, "dataRecieved")

func _process(delta):
	websocket.poll()

func dataRecieved():
	var data = websocket.get_peer(1).get_packet().get_string_from_utf8()
	var json = JSON.parse(data)
	if json.result != null:
		for request in json.result:
			pass

func connectionEstablished():
	pass

func connectionClosed(faulty = false):
	pass
