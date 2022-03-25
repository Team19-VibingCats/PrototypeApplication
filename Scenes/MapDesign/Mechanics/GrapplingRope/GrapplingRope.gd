extends Node2D

var attachedPlayer

var fakeRopeScene = preload("res://Scenes/MapDesign/Mechanics/GrapplingRope/FakeGrapplingRope.tscn")
var fakeRope

var length = 0.0

func attach(player,length):
#	look_at(player.global_position)
	
	$DampedSpringJoint2D.set_node_b(player.get_path())
	
	self.length = global_position.distance_to(player.global_position)
	attachedPlayer = player

var volumeTarget = -10.0

func _physics_process(delta):
	$Line2D.set_point_position(1,attachedPlayer.global_position-global_position - (attachedPlayer.global_position-global_position).normalized()*40)
	$AudioStreamPlayer2D.global_position = attachedPlayer.global_position
	
	var distance = global_position.distance_to(attachedPlayer.global_position)
	$AudioStreamPlayer2D.volume_db = lerp($AudioStreamPlayer2D.volume_db,volumeTarget,delta*4)
	if distance < length:
		$DampedSpringJoint2D.stiffness = 0.0
		volumeTarget = -200
	else:
		$DampedSpringJoint2D.stiffness = 64.0
		volumeTarget = -10

func _enter_tree():
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"instanceObject",{"instance": "rope","name": name},false)

func _exit_tree():
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"removeFakeObject",get_path(),false)
