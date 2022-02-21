extends Node2D

onready var body = $KinematicBody2D

func _ready():
	pass

func _process(delta):
	handleInputs()

func handleInputs():
	var moveDirection = Vector2(0,0)
	if Input.is_action_pressed("Left"):
		moveDirection.x -= 1
	if Input.is_action_pressed("Right"):
		moveDirection.x += 1
	if Input.is_action_pressed("Up"):
		moveDirection.y += 1
	if Input.is_action_pressed("Down"):
		moveDirection.y -= 1
	
	body.setMoveDirection(moveDirection)
