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
	if !is_instance_valid(target1) && !is_instance_valid(target2):
		queue_free()
		set_process(false)
		return
	
	simulateRope(delta)
	drawRope()

func drawRope():
	$RopeAnchor.position = target1.position
	$RopeAnchor.look_at(target2.position)
	$RopeAnchor.scale.x = target1.position.distance_to(target2.position)

func simulateRope(delta):
	var d = target1.position.distance_to(target2.position)
	if d > ropeLength:
		target1Force = (target2.position - target1.position).normalized()*pullForce
		target2Force = (target1.position - target2.position).normalized()*pullForce
	else:
		target1Force = Vector2(0,0)
		target2Force = Vector2(0,0)
	
	applyForces(delta)

func applyForces(delta):
	target1ActualForce = target1ActualForce.linear_interpolate(target1Force,delta)
	target2ActualForce = target2ActualForce.linear_interpolate(target2Force,delta)
