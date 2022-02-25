extends Node2D

onready var body = $Body

var fake = false

func _ready():
	name = TokenHandler.username
	
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"instanceObject",{"instance": "player","name": name},true)

func _process(delta):
	handleInputs()

func handleInputs():
	if fake: return
	
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
