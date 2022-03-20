tool
extends StaticBody2D

export var targetOffset = Vector2.ZERO setget setOffset
export var timeToMove = 1.0
export var pauseTime = 0.0

export var progressAmount = 0.0

onready var originalPosition = global_position
onready var targetPosition = $Target.global_position

func _ready():
	if !Engine.editor_hint:
		$Target.queue_free()
		$AnimationPlayer.playback_speed = 1.0/timeToMove
		$AnimationPlayer.play("MoveForward")

func _physics_process(delta):
	if !Engine.editor_hint && TokenHandler.host:
		position = lerp(originalPosition,targetPosition,progressAmount)

func finishMoving():
	if pauseTime > 0:
		$AnimationPlayer.playback_speed = 1.0/pauseTime
		$AnimationPlayer.play("Wait")
	else:
		$AnimationPlayer.playback_speed = 1.0/timeToMove
		if progressAmount > 0.5:
			$AnimationPlayer.play("MoveBackward")
		else:
			$AnimationPlayer.play("MoveForward")

func finishPause():
	$AnimationPlayer.playback_speed = 1.0/timeToMove
	if progressAmount > 0.5:
		$AnimationPlayer.play("MoveBackward")
	else:
		$AnimationPlayer.play("MoveForward")

func setOffset(newOffset):
	targetOffset = newOffset
	$Target.position = targetOffset
