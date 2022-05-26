extends Entity


func _ready():
	speed = 80

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		moving = true
		if event.scancode == KEY_ESCAPE and event.pressed:
			turns_towards("left")
		elif event.scancode == KEY_SPACE and event.pressed:
			turns_towards("right")
	else:
		moving = false
	
