extends Node2D

var throwing = false
var throwProgress = 0.0
var targetLength = 0.0
var succesfullThrow = false
export var maxLength = 400

var ropeScene = preload("res://Scenes/MapDesign/Mechanics/GrapplingRope/GrapplingRope.tscn")
var currentRope = null

var globalTarget = Vector2.ZERO

func _ready():
	$RayCast2D.cast_to.x = maxLength

func throw():
	if !throwing:
		throwing = true
		
		if $RayCast2D.is_colliding():
			succesfullThrow = true
			globalTarget = $RayCast2D.get_collision_point()
			targetLength = globalTarget.distance_to(global_position)
			$Target.position.x = targetLength
		else:
			succesfullThrow = false
			targetLength = maxLength
			$Target.position.x = maxLength

func _physics_process(delta):
	if !throwing:
		look_at(get_viewport().get_mouse_position()+global_position-get_viewport_rect().size/2.0)
	else:
		throwProgress += delta*2000
		
		if succesfullThrow:
			targetLength = globalTarget.distance_to(global_position)
			$Target.position.x = targetLength
		
		if throwProgress > targetLength:
			throwProgress = 0
			throwing = false
			
			if succesfullThrow:
				instanceRope()
		
		$Line2D.set_point_position(1,Vector2(throwProgress,0))

func instanceRope():
	deleteRope()
	
	var player = get_parent()
	currentRope = ropeScene.instance()
	currentRope.name = "Rope"+TokenHandler.name
	
	get_tree().current_scene.add_child(currentRope)
	currentRope.global_position = $Target.global_position
	currentRope.attach(player,targetLength)
	loosenPlayer()

func deleteRope():
	if currentRope != null:
		currentRope.queue_free()
		currentRope = null
		rigidPlayer()

func loosenPlayer():
	var player = get_parent()
	player.mode = RigidBody2D.MODE_RIGID

func rigidPlayer():
	var player = get_parent()
	player.mode = RigidBody2D.MODE_CHARACTER
	player.call_deferred("set","rotation_degrees", 0)
#	player. = 0

func _input(event):
	if event.is_action_pressed("LeftClick"):
		throw()
	if event.is_action_released("LeftClick"):
		deleteRope()
