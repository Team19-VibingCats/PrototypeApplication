extends Node2D



func _on_Join_pressed():
	if $LineEdit.text.length() > 0:
		TokenHandler.worldName = $LineEdit.text
		TokenHandler.login()

func _on_Host_pressed():
	if $LineEdit.text.length() > 0:
		TokenHandler.worldName = $LineEdit.text
		TokenHandler.createWorld()

func _process(delta):
	if TokenHandler.loggedIn:
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/Lobby.tscn")
