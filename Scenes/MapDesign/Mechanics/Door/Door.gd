extends Node2D

var open = false
export var vibrate = false

var originalPosition = position

func _ready():
	set_process(false)

func openDoor():
	if open: return
	open = true
	if vibrate: set_process(true)
	
	$AnimationPlayer.play("OpenDoor")

func _process(delta):
	$DoorAnchor.position = Vector2.ZERO
	$DoorAnchor.position += Vector2(rand_range(-1,1),rand_range(-1,1))*1
