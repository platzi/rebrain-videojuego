extends KinematicBody2D


class_name Entity


onready var animation_tree = $AnimationTree
onready var move_vector = animation_tree.get("parameters/Idle/blend_position")
onready var animation_state = animation_tree.get("parameters/playback")
var moving = false
var speed = 100


func turns_towards(towards : String) -> void:
	if towards.to_lower() == "left":
		#(1, 0) -> (0, -1) -> (-1, 0) -> (0, 1)
		#(-1, -1) -- (-1, 1) -- (1, 1) -- (1, -1)
		if move_vector.x > 0:
			move_vector += Vector2(-1, -1)
		else:
			move_vector += Vector2(1, 1)
		
		if move_vector.y > 0:
			move_vector += Vector2(1, -1)
		else:
			move_vector += Vector2(-1, 1)
	elif towards.to_lower() == "right":
		#(1, 0) -> (0, 1) -> (-1, 0) -> (0, -1)
		#(-1, 1) -- (-1, -1) -- (1, -1) -- (1, 1)
		if move_vector.x > 0:
			move_vector += Vector2(-1, 1)
		else:
			move_vector += Vector2(1, -1)
		
		if move_vector.y > 0:
			move_vector += Vector2(-1, -1)
		else:
			move_vector += Vector2(1, 1)
	animation_tree.set("parameters/Idle/blend_position", move_vector)
	

func move_forward() -> void:
	moving = true


func stop_moving() -> void:
	moving = false


func _physics_process(delta : float) -> void:
	if moving:
		animation_tree.set("parameters/Move/blend_position", move_vector)
		animation_state.travel("Move")
		move_and_slide(move_vector * speed)
	else:
		animation_state.travel("Idle")
