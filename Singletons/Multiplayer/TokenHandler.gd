extends Node

var token = ""
var worldName = ""
var username = ""
var color = Color.white

var host = false

var loggedIn = false

var synchronizers = []



func createWorld():
	$CreateWorldRequest.request(GlobalConstants.serverAddress+"/world/create", 
	["Content-Type: application/json"],
	false, 
	HTTPClient.METHOD_POST, getWorldData())

func login():
	$LoginRequest.request(GlobalConstants.serverAddress+"/player/login/"+worldName, 
	["Content-Type: application/json"],
	false, 
	HTTPClient.METHOD_POST, getUserData())

func getWorldData():
	var array = {
	"serverTime": 0,
	"name": worldName
	}
	
	return JSON.print(array)

func getUserData():
	var array = {
	"name": username,
	"lastRequest": 0,
	}
	
	return JSON.print(array)

func _on_LoginRequest_request_completed(result, response_code, headers, body):
	print(response_code)
	print(body.get_string_from_utf8())
	
	var data = body.get_string_from_utf8()
	var json = JSON.parse(data)
	if json.result != null:
		if response_code == 200:
			token = json.result["token"]
			loggedIn = true

func _on_CreateWorldRequest_request_completed(result, response_code, headers, body):
	print(response_code)
	print(body.get_string_from_utf8())
	
	if response_code == 200:
		login()

func isHost():
	print("Client is now the host")
	host = true
	notifySynchronizers()

func isClient():
	print("Client is not the host")
	host = false
	notifySynchronizers()

func notifySynchronizers():
	for synchronizer in synchronizers:
		synchronizer.statusUpdated()
