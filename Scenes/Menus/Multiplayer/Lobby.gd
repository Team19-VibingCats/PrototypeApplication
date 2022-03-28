extends Control

var lobbyTimer = 2.0

func _ready():
	$CenterContainer/VBoxContainer/Label.text = "Lobby: "+TokenHandler.worldName

func _process(delta):
	lobbyTimer += delta
	
	if lobbyTimer > 1:
		lobbyTimer = 0.0
		retrieveLobby()

func retrieveLobby():
	$RetrieveLobby.request(GlobalConstants.serverAddress+"/player/"+TokenHandler.token+"/lobby/"+TokenHandler.worldName, 
	["Content-Type: application/json"],
	false, 
	HTTPClient.METHOD_GET, TokenHandler.getUserData())

func _on_RetrieveLobby_request_completed(result, response_code, headers, body):
	print(response_code)
	
	var data = body.get_string_from_utf8()
	var json = JSON.parse(data)
	
	if json.result != null:
		if response_code == 200:
			$CenterContainer/VBoxContainer/LobbyList.text = ""
			
			for playerString in json.result:
				var player = JSON.parse(playerString).result
				$CenterContainer/VBoxContainer/LobbyList.text += player["name"]
				$CenterContainer/VBoxContainer/LobbyList.text += "\n"

func _on_EnterWorld_request_completed(result, response_code, headers, body):
	if response_code == 200:
		RequestHandler.tryToConnect()
		get_tree().change_scene("res://Scenes/Main/Level_1.tscn")



func _on_StartButton_pressed():
	$EnterWorld.request(GlobalConstants.serverAddress+"/player/"+TokenHandler.token+"/enterWorld/"+TokenHandler.worldName, 
	["Content-Type: application/json"],
	false, 
	HTTPClient.METHOD_POST)


func _on_Back_pressed():
	TokenHandler.loggedIn = false
	get_tree().change_scene("res://Scenes/Menus/Multiplayer/WorldScreen.tscn")
