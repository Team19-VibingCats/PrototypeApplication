extends Node2D

func _ready():
	$LineEdit.text = TokenHandler.username
	$ColorPickerAnchor/Panel/ColorPicker.color = TokenHandler.color

func _on_Button_pressed():
	if $LineEdit.text.length() > 1:
		TokenHandler.username = $LineEdit.text
		TokenHandler.color = $ColorPickerAnchor/Panel/ColorPicker.color
		get_tree().change_scene("res://Scenes/Menus/Multiplayer/WorldScreen.tscn")

func _process(delta):
	$Mantel.modulate = $ColorPickerAnchor/Panel/ColorPicker.color
