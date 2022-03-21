extends KinematicBody2D

signal hitGround

export var gravity = 1.0
export var accelaration = 1.0
export var damp = 1.0
export var jumpVelocity = 1.0
export var jumpLength = 1.0
export var spinHeightBoost = 200.0
export(CurveTexture) var jumpCurve
export(Array,NodePath) var characterSpritePaths
var characterSprites = []

var moveDirection = Vector2(0,0)
var currentVelocity = Vector2(0,0)
var externalVelocity = Vector2(0,0)

var connectedByRope = false

var currentJumpLength = 0.0

var touchingGround = false
var justJumped = false

func _ready():
	for spritePath in characterSpritePaths:
		characterSprites.append(get_node(spritePath))
		get_node(spritePath).frame = 0

func _physics_process(delta):
	groundDetection()
	moveBody(delta)
	handleSprite()

var justSpinned = false
func spin():
	var animationPlayer = get_parent().get_node("AnimationPlayer")
	
	if !animationPlayer.is_playing() && !justSpinned:
		justSpinned = true
		animationPlayer.play("Spin")
		FunctionCallHandler.requestFunctionCall(animationPlayer,"play","Spin")
		
		if !touchingGround:
			if currentVelocity.y > 0: 
				currentVelocity.y = 0
				currentVelocity.y -= spinHeightBoost*2
			else:
				currentVelocity.y -= spinHeightBoost
			
			playSpinParticles()

func playSpinParticles():
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	FunctionCallHandler.requestFunctionCall(self,"playSpinParticles")

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
			playAnimation({"Animation": "Jump", "Reset": true, "Block": true})
			
			if get_parent().get_node("AnimationPlayer").is_playing():
				playSpinParticles()
				currentVelocity.y -= spinHeightBoost
				justSpinned = true
		else:
			currentJumpLength = clamp(currentJumpLength+delta,0,jumpLength)
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
	if touchingGround: justSpinned = false

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
		
		for sprite in characterSprites:
			sprite.flip_h = flip

func playAnimation(animationData):
	if animationBlocked: return
	
	for sprite in characterSprites:
		if animationData["Reset"]: sprite.stop()
		sprite.play(animationData["Animation"])
	
	if animationData["Block"]:
		animationBlocked = true
	
	FunctionCallHandler.requestFunctionCall(self,"playAnimation",animationData)

func _on_AnimatedSprite_animation_finished():
	animationBlocked = false
