extends Node

var websocket = WebSocketClient.new()

var pendingRequests = []
var waitingSynchronizers = []
var transmitCooldown = 0.0

var connected = false

#Connection logic-----------------------------------------------------------------------------------
func _ready():
	websocket.connect("connection_closed", self, "connectionClosed")
	websocket.connect("connection_error", self, "connectionClosed")
	websocket.connect("connection_established", self, "connectionEstablished")
#	websocket.connect("data_received", self, "dataRecieved")

func tryToConnect():
	websocket.connect_to_url(GlobalConstants.serverAddress+"/socket")

func connectionEstablished(message):
	print("connection established")
	connected = true

func connectionClosed(faulty = false):
	print("connection failed")
	print(faulty)
	connected = false
	if faulty:
		tryToConnect()

func _process(delta):
	retrieveData()
	attemptDataTransmit(delta)

#Data retrieval-------------------------------------------------------------------------------------
func retrieveData():
	websocket.poll()
	if websocket.get_peer(1).get_available_packet_count() > 0:
		var body = websocket.get_peer(1).get_packet()
		
		var compressedBytes = body
		var uncompressedBytes = body.decompress_dynamic(-1,3)
		
		var json = JSON.parse(uncompressedBytes.get_string_from_utf8())
		
		if json.result != null:
			for request in json.result:
				processRequest(request)

func processRequest(requestString):
	if requestString.left(1) != "{": requestString = "{ "+requestString
	
	var request = str2var(requestString)
	match request["type"]:
		"setProperty":
			PropertiesHandler.setProperty(request["nodePath"], request["propertyPath"], request["value"], request["interpolate"], request["interpolateSpeed"])
		"functionCall":
			FunctionCallHandler.callFunction(request["nodePath"],request["functionName"],request["parameters"])

#Data transmitting----------------------------------------------------------------------------------
func requestSync(data, persistent, synchronizer = null):
	pendingRequests.append("#"+str(persistent)+"%"+data)
	if synchronizer: waitingSynchronizers.append(synchronizer)

func attemptDataTransmit(delta):
	transmitCooldown -= delta
	
	if transmitCooldown <= 0:
		transmitCooldown = 0.05
		
		if connected:
			sendPendingRequests()
			alertSynchronizers()

func sendPendingRequests():
	var requestString = ""
	for request in pendingRequests:
		requestString += request
	var dataString = requestString + "&" + TokenHandler.token + "&" + TokenHandler.worldName
	websocket.get_peer(1).set_write_mode(1)
	websocket.get_peer(1).put_packet(dataString.to_utf8().compress(3))
	pendingRequests.clear()

func alertSynchronizers():
	for synchronizer in waitingSynchronizers:
		if is_instance_valid(synchronizer):
			synchronizer.waitingForSync = false
	
	waitingSynchronizers.clear()
