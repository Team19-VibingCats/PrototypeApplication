extends Node2D

var attachedPlayer

var fakeRopeScene = preload("res://Scenes/MapDesign/Mechanics/GrapplingRope/FakeGrapplingRope.tscn")
var fakeRope

func attach(player,length):
#	look_at(player.global_position)
	
	$DampedSpringJoint2D.set_node_b(player.get_path())
	
#	$DampedSpringJoint2D.length = length
	
	attachedPlayer = player

func _physics_process(delta):
	$Line2D.set_point_position(1,attachedPlayer.global_position-global_position - (attachedPlayer.global_position-global_position).normalized()*40)

func _enter_tree():
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"instanceObject",{"instance": "rope","name": name},false)

func _exit_tree():
	FunctionCallHandler.requestFunctionCall(FakeObjectHandler,"removeFakeObject",get_path(),false)
