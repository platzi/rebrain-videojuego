extends KinematicBody2D


const MAX_SPEED = 200
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
onready var animation_player = $AnimationPlayer

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")


func _physics_process(_delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Move/blend_position", input_vector)
		animation_state.travel("Move")
		print(velocity)
	else:
		animation_state.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
