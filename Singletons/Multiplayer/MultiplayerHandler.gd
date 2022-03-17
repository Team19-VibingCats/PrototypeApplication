extends Node

var websocket = WebSocketClient.new()

func _ready():
	websocket.connect("connection_closed", self, "connectionClosed")
	websocket.connect("connection_error", self, "connectionClosed")
	websocket.connect("connection_established", self, "connectionEstablished")
	websocket.connect("data_received", self, "dataRecieved")
	tryToConnect()

func tryToConnect():
	websocket.connect_to_url("http://134.122.50.55:8080/MultiplayerServer-prototype-1/socket")

func _process(delta):
	websocket.poll()

func dataRecieved():
	var data = websocket.get_peer(1).get_packet().get_string_from_utf8()
	var json = JSON.parse(data)
	if json.result != null:
		for request in json.result:
			processRequest(request)

func connectionEstablished():
	pass

func connectionClosed(faulty = false):
	if faulty:
		tryToConnect()

func processRequest(request):
	match request["type"]:
		"setProperty":
			pass
		"functionCall":
			pass
