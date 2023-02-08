extends KinematicBody2D


const MAX_SPEED = 200
var speed = 100
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var inmunity = false
var inmunity_time = 1
var move_towards_vector := Vector2.ZERO
var is_moving_towards = false

onready var area_2d := $Area2D
onready var audio_stream_player := $AudioStreamPlayer2D
onready var teleport_animation_player := $TeleportAnimationPlayer
onready var animation_tree := $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var inmunity_timer := $InmunityTimer
onready var hit_animation_player := $HitAnimationPlayer
onready var hair_sprite := $Sprite/HairSprite
onready var sprite := $Sprite


var player_name : String = SaveManager.save_data["customization"]["player_name"]
var hair_style : int = SaveManager.save_data["customization"]["hair_style"]
var hair_color : int = SaveManager.save_data["customization"]["hair_color"]
var skin_color : int = SaveManager.save_data["customization"]["skin_color"]
var shirt_color : int = SaveManager.save_data["customization"]["shirt_color"]
var pants_color : int = SaveManager.save_data["customization"]["pants_color"]
var shoes_color : int = SaveManager.save_data["customization"]["shoes_color"]


func _ready() -> void:
	teleport_animation_player.play("RESET")
	inmunity_timer.connect("timeout", self, "remove_inmunity")
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


func remove_inmunity() -> void:
	inmunity = false
	hit_animation_player.play("RESET")


func hurt(knockback_direction : Vector2) -> void:
	if not inmunity:
		inmunity = true
		life -= 1
		velocity = knockback_direction * MAX_SPEED * 8
		inmunity_timer.start(inmunity_time)
		hit_animation_player.play("Hit")
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
