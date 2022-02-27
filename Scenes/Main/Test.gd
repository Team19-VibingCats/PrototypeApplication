extends Sprite

var originalPos = position

var t = 0

func _process(delta):
	t+= delta*2
	
	position = originalPos
	position.x += sin(t)*200
