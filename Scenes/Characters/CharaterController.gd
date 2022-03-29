extends RigidBody2D

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
var externalVelocity = Vector2(0,0)

var connectedByRope = false

var currentJumpLength = 0.0

var touchingGround = false
var groundJitterFix = 1.0
var touchingCeiling = false
var justJumped = false

var spinCooldown = 0.0

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
		$Spin.play()
		FunctionCallHandler.requestFunctionCall($Spin,"play")
		FunctionCallHandler.requestFunctionCall(animationPlayer,"play","Spin")
		
		if !touchingGround && spinCooldown <= 0.0:
			spinCooldown = 0.2
			
			if linear_velocity.y > 0:
				linear_velocity.y = 0
				linear_velocity.y -= spinHeightBoost*2
			else:
				linear_velocity.y -= spinHeightBoost
			
			playSpinParticles()

func playSpinParticles():
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	FunctionCallHandler.requestFunctionCall(self,"playSpinParticles")

func moveBody(delta):
	#	Applying velocity and dampening
	linear_velocity.x += moveDirection.x*accelaration*delta
	linear_velocity.x *= damp
	spinCooldown -= delta
	
#	Jump logic
	if moveDirection.y == 1:
		if touchingGround:
			currentJumpLength = 0.0
			groundJitterFix = -1.0
			touchingGround = false
			$Jump.play()
			FunctionCallHandler.requestFunctionCall($Jump,"play")
			playAnimation({"Animation": "Jump", "Reset": true, "Block": true})
			
			if get_parent().get_node("AnimationPlayer").is_playing() && spinCooldown <= 0.0:
				spinCooldown = 0.2
				playSpinParticles()
				linear_velocity.y -= spinHeightBoost
				justSpinned = true
		else:
			currentJumpLength = clamp(currentJumpLength+delta,0,jumpLength)
	else:
		currentJumpLength = jumpLength
	
	var jumpIntensity = jumpCurve.curve.interpolate(currentJumpLength/jumpLength)
	linear_velocity.y -= jumpVelocity*jumpIntensity*delta
	
#	Moving the body and saving the returned velocity
#	linear_velocity

func groundDetection():
	$GroundDetector.global_position = global_position
	$GroundDetector.move_and_slide(Vector2.ZERO,Vector2.UP,true,4,0.78,false)
	
	if $GroundDetector.is_on_floor():
		groundJitterFix = 1.0
		if !touchingGround:
			$Land.play()
			FunctionCallHandler.requestFunctionCall($Land,"play")
			emit_signal("hitGround")
	else:
		groundJitterFix -= 0.2
	
	touchingCeiling = $GroundDetector.is_on_ceiling()
	touchingGround = groundJitterFix > 0
	if touchingGround && spinCooldown <= 0.0: justSpinned = false

func setMoveDirection(direction):
	moveDirection = direction



#Sprite handling------------------------------------------------------------------------------------
var animationBlocked = false
func handleSprite():
	if !touchingGround:
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
