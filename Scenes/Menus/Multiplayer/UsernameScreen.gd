extends Node2D



func _on_Button_pressed():
	if $LineEdit.text.length() > 1:
		TokenHandler.username = $LineEdit.text
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/WorldScreen.tscn")
