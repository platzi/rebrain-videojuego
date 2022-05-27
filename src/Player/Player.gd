extends KinematicBody2D


const MAX_SPEED = 200
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var inmunity = false

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var inmunity_timer := $InmunityTimer


func _ready():
	inmunity_timer.connect("timeout", self, "remove_inmunity")


func remove_inmunity():
	inmunity = false


func hurt(move_vector : Vector2) -> void:
	if !inmunity:
		inmunity = true
		life -= 1
		position = position + move_vector * 15
		inmunity_timer.start(1)


func _physics_process(_delta : float) -> void:
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * MAX_SPEED
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Move/blend_position", input_vector)
		animation_state.travel("Move")
		velocity = move_and_slide(velocity)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("Projectile"):
				collision.collider.hit()

				hurt(collision.collider.velocity_vector)
	else:
		animation_state.travel("Idle")

