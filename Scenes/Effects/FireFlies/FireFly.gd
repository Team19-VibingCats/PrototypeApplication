extends Node2D

var direction = Vector2.ONE
var currentSpeed = 0.0

var noise = OpenSimplexNoise.new()

func _ready():
	noise.seed = rand_range(0,10000)

func _physics_process(delta):
	setSpeed(delta)
	setDirection(delta)
	
	position += direction*currentSpeed*50*delta

func setSpeed(delta):
	var newSpeed = noise.get_noise_2d(position.x,position.y) + 1.0
	
	currentSpeed = lerp(currentSpeed,newSpeed,delta)

func setDirection(delta):
	var newDirection = Vector2(noise.get_noise_1d(position.x*100), noise.get_noise_1d(position.y*100)).normalized()
	
	direction = lerp(direction,newDirection,delta*10).normalized()
