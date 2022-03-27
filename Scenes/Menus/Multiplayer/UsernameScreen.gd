extends Control

func _ready():
	$CenterContainer/VBoxContainer/LineEdit.text = TokenHandler.username
	$CenterContainer/VBoxContainer/Panel/ColorPicker.color = TokenHandler.color

func _on_Button_pressed():
	if $CenterContainer/VBoxContainer/LineEdit.text.length() > 1:
		TokenHandler.username = $CenterContainer/VBoxContainer/LineEdit.text
		TokenHandler.color = $CenterContainer/VBoxContainer/Panel/ColorPicker.color
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/WorldScreen.tscn")

func _process(delta):
	$CenterContainer/VBoxContainer/Control/Mantel.modulate = $CenterContainer/VBoxContainer/Panel/ColorPicker.color
