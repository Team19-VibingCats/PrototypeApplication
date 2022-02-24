extends Node2D

var lobbyTimer = 2.0

func _process(delta):
	lobbyTimer += delta
	
	if lobbyTimer > 2:
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
			$LobbyList.text = ""
			
			for player in json.result:
				$LobbyList.text += "\n"
				$LobbyList.text += player["name"]




func _on_StartButton_pressed():
	RequestHandler.tryToConnect()
	get_tree().change_scene("res://Scenes/Main/MainScene.tscn")
