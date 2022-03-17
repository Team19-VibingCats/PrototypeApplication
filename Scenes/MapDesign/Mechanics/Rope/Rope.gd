extends Node2D

var target1
var target1Force = Vector2(0,0)
var target1ActualForce = Vector2(0,0)

var target2
var target2Force = Vector2(0,0)
var target2ActualForce = Vector2(0,0)

export var ropeLength = 200.0
export var pullForce = 1.0

func _enter_tree():
	set_process(false)

func connectRope(a,b):
	target1 = a
	target2 = b
	a.connectedByRope = true
	b.connectedByRope = true
	set_process(true)

func _process(delta):
	if !is_instance_valid(target1) || !is_instance_valid(target2):
		queue_free()
		set_process(false)
		return
	
	simulateRope(delta)
	drawRope()

func drawRope():
	$RopeAnchor.position = target1.global_position
	$RopeAnchor.look_at(target2.global_position)
	$RopeAnchor.scale.x = target1.global_position.distance_to(target2.global_position)

func simulateRope(delta):
	var d = abs(target1.global_position.distance_to(target2.global_position))
	
	if d > ropeLength:
		var pullAmount = ((d-ropeLength)*(d-ropeLength))*pullForce
		target1Force = (target2.global_position - target1.global_position).normalized()*pullAmount
		target2Force = (target1.global_position - target2.global_position).normalized()*pullAmount
	else:
		target1Force = Vector2(0,0)
		target2Force = Vector2(0,0)
	
	applyForces(delta)

func applyForces(delta):
	target1ActualForce = target1ActualForce.linear_interpolate(target1Force,delta*5)
	target2ActualForce = target2ActualForce.linear_interpolate(target2Force,delta*5)
	target1.externalVelocity += target1ActualForce*delta
	target2.externalVelocity += target2ActualForce*delta
