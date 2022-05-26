extends Entity


func _ready():
	speed = 40

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		moving = true
	else:
		moving = false
