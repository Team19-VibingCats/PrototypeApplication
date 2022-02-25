extends Node2D

onready var body = $Body

var fake = false

func _ready():
	name = TokenHandler.username
	$Body/Sprite.self_modulate = TokenHandler.color
	
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"instanceObject",{"instance": "player","name": name},true)
	PropertiesHandler.requestPropertySync($Body/Sprite,"self_modulate",TokenHandler.color,false,true)

func _physics_process(delta):
	handleInputs()
	moveCamera(delta)

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

func moveCamera(delta):
	$Camera2D.position = lerp($Camera2D.position,$Body.position,delta*2)