extends Node2D




func _on_Button_pressed():
	if $LineEdit.text.length() > 1:
		TokenHandler.username = $LineEdit.text
		TokenHandler.color = $Panel/ColorPicker.color
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/WorldScreen.tscn")
