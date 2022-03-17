extends KinematicBody2D

signal hitGround

export var gravity = 1.0
export var accelaration = 1.0
export var damp = 1.0
export var jumpVelocity = 1.0
export var jumpLength = 1.0
export(CurveTexture) var jumpCurve
export(NodePath) var characterSprite

var moveDirection = Vector2(0,0)
var currentVelocity = Vector2(0,0)
var externalVelocity = Vector2(0,0)

var connectedByRope = false

var currentJumpLength = 0.0

var touchingGround = false
var justJumped = false

func _ready():
	characterSprite = get_node(characterSprite)

func _physics_process(delta):
	groundDetection()
	moveBody(delta)
	handleSprite()

func moveBody(delta):
	#	Applying velocity and dampening
	if externalVelocity.y >= 0:
		currentVelocity.y += gravity*delta
	else:
		currentVelocity.y += gravity*delta*0.1
	currentVelocity.x += moveDirection.x*accelaration*delta
	currentVelocity.x *= damp
	
#	Jump logic
	if moveDirection.y == 1 && !is_on_ceiling():
		if touchingGround:
			currentJumpLength = 0.0
		else:
			currentJumpLength = clamp(currentJumpLength+delta,0,jumpLength)
			playAnimation({"Animation": "Jump", "Reset": true, "Block": true})
	else:
		currentJumpLength = jumpLength
	
	var jumpIntensity = jumpCurve.curve.interpolate(currentJumpLength/jumpLength)
	currentVelocity.y -= jumpVelocity*jumpIntensity*delta
	
	move_and_slide(externalVelocity,Vector2.UP,true,4,0.78,false)
	externalVelocity = Vector2.ZERO
	
#	Moving the body and saving the returned velocity
	currentVelocity = move_and_slide(currentVelocity,Vector2.UP,true,4,0.78,false)

func groundDetection():
	if is_on_floor():
		if !touchingGround:
			emit_signal("hitGround")
	
	touchingGround = is_on_floor()

func setMoveDirection(direction):
	moveDirection = direction



#Sprite handling------------------------------------------------------------------------------------
var animationBlocked = false
func handleSprite():
	if currentVelocity.y > 0:
		playAnimation({"Animation": "Fall", "Reset": false, "Block": false})
		return
	
	if moveDirection.x == 0: 
		playAnimation({"Animation": "Idle", "Reset": false, "Block": false})
	else:
		playAnimation({"Animation": "Walk", "Reset": false, "Block": false})
		var flip = moveDirection.x > 0
		characterSprite.flip_h = flip

func playAnimation(animationData):
	if animationBlocked: return
	
	if animationData["Reset"]: characterSprite.stop()
	characterSprite.play(animationData["Animation"])
	
	if animationData["Block"]:
		animationBlocked = true
	
	FunctionCallHandler.requestFunctionCall(self,"playAnimation",animationData)

func _on_AnimatedSprite_animation_finished():
	animationBlocked = false

func setSpriteColor(color):
	pass
#	for sprite in sprites:
#		if sprite.material != null:
#			var newMaterial = sprite.material.duplicate()
#			newMaterial.set("shader_param/newColor",color)
#			sprite.material = newMaterial
