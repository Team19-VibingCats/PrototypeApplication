extends Control



func _on_Join_pressed():
	if $CenterContainer/VBoxContainer/LineEdit.text.length() > 0:
		TokenHandler.worldName = $CenterContainer/VBoxContainer/LineEdit.text
		TokenHandler.login()

func _on_Host_pressed():
	if $CenterContainer/VBoxContainer/LineEdit.text.length() > 0:
		TokenHandler.worldName = $CenterContainer/VBoxContainer/LineEdit.text.replace(" ", "-")
		TokenHandler.createWorld()

func _process(delta):
	if TokenHandler.loggedIn:
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/Lobby.tscn")


func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Menus/Multiplayer/UsernameScreen.tscn")
