extends Node2D

var timeNotMoved = 0.0

var lastPosition = Vector2.ZERO

func _physics_process(delta):
	movementCheck(delta)
	needsCollision()
	positionCollisionShape()

func movementCheck(delta):
	timeNotMoved += delta
	
	if lastPosition.distance_to($Line2D.get_point_position(1)) > 30:
		timeNotMoved = 0.0
		lastPosition = $Line2D.get_point_position(1)

func positionCollisionShape():
	$CollisionAnchor.global_position = global_position + $Line2D.get_point_position(0)
	$CollisionAnchor.look_at(global_position + $Line2D.get_point_position(1))
	$CollisionAnchor.scale.x = $Line2D.get_point_position(0).distance_to($Line2D.get_point_position(1))

func needsCollision():
	var angle = $Line2D.get_point_position(0).angle_to_point($Line2D.get_point_position(1))
	
	if timeNotMoved > 1 && ((angle > -PI/4 && angle < PI/4) || (angle < -PI+PI/4 || angle > PI - PI/4)):
		$CollisionAnchor/StaticBody2D/CollisionShape2D.disabled = false
	else:
		$CollisionAnchor/StaticBody2D/CollisionShape2D.disabled = true
