extends Node2D

onready var body = $Body

var fake = false

func _ready():
	name = TokenHandler.username
	
	if !GlobalVariables.initialPlayerSync:
		GlobalVariables.initialPlayerSync = true
		FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"instanceObject",{"instance": "player","name": name},true)
	#	FunctionCallHandler.requestFunctionCall($Body,"setSpriteColor",TokenHandler.color,true)
		PropertiesHandler.requestPropertySync($Body/Label,"self_modulate",TokenHandler.color,false,true)
		PropertiesHandler.requestPropertySync($Body/Label,"text",TokenHandler.username,false,true)
		
		PropertiesHandler.requestPropertySync($Body/Sprites/Mantel,"modulate",TokenHandler.color,false,true)
	
	$Body/Sprites/Mantel.modulate = TokenHandler.color

func _physics_process(delta):
	handleInputs()
	moveCamera(delta)

func handleInputs():
	var moveDirection = Vector2(0,0)
	
	if GlobalConstants.controlsDisabled:
		body.setMoveDirection(moveDirection)
		return
	
	if Input.is_action_pressed("Left"):
		moveDirection.x -= 1
	if Input.is_action_pressed("Right"):
		moveDirection.x += 1
	if Input.is_action_pressed("Up"):
		moveDirection.y += 1
	if Input.is_action_pressed("Down"):
		moveDirection.y -= 1
	
	if Input.is_action_pressed("spin"):
		body.spin()
	
	body.setMoveDirection(moveDirection)

func moveCamera(delta):
	$Camera2D.position = lerp($Camera2D.position,$Body.position,delta*6)
