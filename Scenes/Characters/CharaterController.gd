extends KinematicBody2D

export var gravity = 1.0
export var accelaration = 1.0
export var damp = 1.0
export var jumpVelocity = 1.0
export var jumpLength = 1.0
export(CurveTexture) var jumpCurve

var moveDirection = Vector2(0,0)
var currentVelocity = Vector2(0,0)

var currentJumpLength = 0.0

func _physics_process(delta):
#	Applying velocity and dampening
	currentVelocity.y += gravity*delta
	currentVelocity.x += moveDirection.x*accelaration*delta
	currentVelocity.x *= damp
	
#	Jump logic
	if moveDirection.y == 1:
		if is_on_floor():
			currentJumpLength = 0.0
		else:
			currentJumpLength = clamp(currentJumpLength+delta,0,jumpLength)
	else:
		currentJumpLength = jumpLength
	
	var jumpIntensity = jumpCurve.curve.interpolate(currentJumpLength/jumpLength)
	currentVelocity.y -= jumpVelocity*jumpIntensity*delta
	
#	Moving the body and saving the returned velocity
	currentVelocity = move_and_slide(currentVelocity,Vector2.UP,true,4,0.78,false)

func setMoveDirection(direction):
	moveDirection = direction
