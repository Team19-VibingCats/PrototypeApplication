extends Node

var websocket = WebSocketClient.new()

var pendingRequests = []
var waitingSynchronizers = []
var transmitCooldown = 0.0

#Connection logic-----------------------------------------------------------------------------------
func _ready():
	websocket.connect("connection_closed", self, "connectionClosed")
	websocket.connect("connection_error", self, "connectionClosed")
	websocket.connect("connection_established", self, "connectionEstablished")
	websocket.connect("data_received", self, "dataRecieved")

func tryToConnect():
	websocket.connect_to_url(GlobalConstants.serverAddress+"/socket")

func connectionEstablished(message):
	print("connection established")

func connectionClosed(faulty = false):
	print("connection failed")
	if faulty:
		tryToConnect()

func _process(delta):
	websocket.poll()
	attemptDataTransmit(delta)

#Data retrieval-------------------------------------------------------------------------------------
func dataRecieved():
	var data = websocket.get_peer(1).get_packet().get_string_from_utf8()
	var json = JSON.parse(data)
	if json.result != null:
		for request in json.result:
			processRequest(request)

func processRequest(request):
	match request["type"]:
		"setProperty":
			pass
		"functionCall":
			pass

#Data transmitting----------------------------------------------------------------------------------
func requestSync(data, persistent, synchronizer):
	pendingRequests.append(str(persistent)+"/"+data)
	if synchronizer: waitingSynchronizers.append(synchronizer)

func attemptDataTransmit(delta):
	transmitCooldown -= delta
	
	if transmitCooldown <= 0:
		transmitCooldown = 0.1
		
		if pendingRequests.size() > 0:
			sendPendingRequests()
			alertSynchronizers()

func sendPendingRequests():
	var dataString = JSON.print(pendingRequests) + "/" + TokenHandler.token + "/" + TokenHandler.worldName
	websocket.get_peer(1).put_packet(dataString.to_utf8())
	pendingRequests.clear()

func alertSynchronizers():
	for synchronizer in waitingSynchronizers:
		synchronizer.waitingForSync = false
	
	waitingSynchronizers.clear()
