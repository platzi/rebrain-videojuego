extends KinematicBody2D


const MAX_SPEED = 200
var speed = 100
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var move_towards_vector := Vector2.ZERO
var is_moving_towards = false

onready var audio_stream_player := $AudioStreamPlayer2D
onready var teleport_animation_player := $TeleportAnimationPlayer
onready var animation_tree := $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var hair_sprite := $Sprite/HairSprite
onready var sprite := $Sprite
onready var hurt_box := $HurtBox


var player_name := ""
var hair_style := 0
var hair_color := 0
var skin_color := 0
var shirt_color := 0
var pants_color := 7
var shoes_color := 0


func _ready() -> void:
	player_name = SaveManager.save_data["customization"]["player_name"]
	hair_style = SaveManager.save_data["customization"]["hair_style"]
	hair_color = SaveManager.save_data["customization"]["hair_color"]
	skin_color = SaveManager.save_data["customization"]["skin_color"]
	shirt_color = SaveManager.save_data["customization"]["shirt_color"]
	pants_color = SaveManager.save_data["customization"]["pants_color"]
	shoes_color = SaveManager.save_data["customization"]["shoes_color"]
	teleport_animation_player.play("RESET")
	hurt_box.connect("hurt", self, "hurt")
	_update_avatar()


func _physics_process(delta : float) -> void:
	if !Globals.disable_inputs:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
	else:
		input_vector = Vector2.ZERO
	if position.distance_to(move_towards_vector) <= 5.0:
		is_moving_towards = false
	if is_moving_towards:
		input_vector = position.direction_to(move_towards_vector)
		input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity += input_vector * speed
		if velocity.distance_to(Vector2.ZERO) > MAX_SPEED:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, delta * MAX_SPEED * 100)
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Move/blend_position", input_vector)
		animation_state.travel("Move")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * MAX_SPEED * 100)
		animation_state.travel("Idle")
	velocity = move_and_slide(velocity)


func hurt(knockback_direction : Vector2) -> void:
	life -= 1
	velocity = knockback_direction * MAX_SPEED * 8
	play_sound()
	Globals.emit_update_life(life)
	if life < 1:
		queue_free()
		Globals.emit_show_game_over()


func _update_avatar() -> void:
	hair_sprite.texture = Customization.HAIR_STYLES[hair_style]
	hair_sprite.material.set_shader_param("HAIR_COLOR", Customization.HAIR_COLORS[hair_color])
	sprite.material.set_shader_param("SKIN_COLOR", Customization.SKIN_COLORS[skin_color])
	sprite.material.set_shader_param("SHIRT_COLOR", Customization.CLOTHES_COLOR[shirt_color])
	sprite.material.set_shader_param("PANTS_COLOR", Customization.CLOTHES_COLOR[pants_color])
	sprite.material.set_shader_param("SHOES_COLOR", Customization.CLOTHES_COLOR[shoes_color])


func move_towards(position : Vector2) -> void:
	move_towards_vector = position
	is_moving_towards = true


func play_sound() -> void:
	audio_stream_player.play()


func teleport() -> void:
	Globals.disable_inputs = true
	Globals.disable_scripting = true
	teleport_animation_player.play("Teleport")
