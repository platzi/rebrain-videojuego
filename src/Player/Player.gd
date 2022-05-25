extends KinematicBody2D

const MAX_SPEED = 8000

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED * delta
		print(velocity)
	else:
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
