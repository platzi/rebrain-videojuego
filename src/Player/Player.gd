extends KinematicBody2D


const MAX_SPEED = 200
var speed = 100
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var inmunity = false
var inmunity_time = 1
var player_name = ""
var move_towards_vector := Vector2.ZERO
var is_moving_towards = false

onready var area_2d := $Area2D
onready var audio_stream_player := $AudioStreamPlayer2D
onready var teleport_animation_player := $TeleportAnimationPlayer
onready var animation_tree := $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var inmunity_timer := $InmunityTimer
onready var hair_sprite := $Sprite/HairSprite


var hair_style := 0
var hair_color := 0
var skin_color := 0
var shirt_color := 0
var pants_color := 0
var shoes_color := 0


func _ready() -> void:
	inmunity_timer.connect("timeout", self, "remove_inmunity")
	change_hair(Customization.HAIR_STYLES[hair_style])
	change_hair_color(Customization.HAIR_COLORS[hair_color])
	change_skin_color(Customization.SKIN_COLORS[skin_color])
	change_shirt(Customization.CLOTHES_COLOR[shirt_color])
	change_pants(Customization.CLOTHES_COLOR[pants_color])
	change_shoes(Customization.CLOTHES_COLOR[shoes_color])
	area_2d.connect("body_entered", self, "_on_body_entered")


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
	$HitAnimationPlayer.play("RESET")


func hurt(knockback_direction : Vector2) -> void:
	if not inmunity:
		inmunity = true
		life -= 1
		velocity = knockback_direction * MAX_SPEED * 8
		inmunity_timer.start(inmunity_time)
		$HitAnimationPlayer.play("Hit")
		play_sound()
		Globals.emit_update_life(life)
	if life < 1:
		queue_free()
		Globals.emit_show_game_over()


func change_hair(hair : Texture) -> void:
	hair_sprite.texture = hair


func change_hair_color(color : Color) -> void:
	hair_sprite.material.set_shader_param("HAIR_COLOR", color)


func change_skin_color(color : Color) -> void:
	$Sprite.material.set_shader_param("SKIN_COLOR", color)


func change_shirt(color : Color) -> void:
	$Sprite.material.set_shader_param("SHIRT_COLOR", color)


func change_pants(color : Color) -> void:
	$Sprite.material.set_shader_param("PANTS_COLOR", color)


func change_shoes(color : Color) -> void:
	$Sprite.material.set_shader_param("SHOES_COLOR", color)


func change_player_name(_name : String) -> void:
	player_name = _name


func move_towards(position : Vector2) -> void:
	move_towards_vector = position
	is_moving_towards = true


func play_sound() -> void:
	audio_stream_player.play()


func teleport() -> void:
	Globals.disable_inputs = true
	Globals.disable_scripting = true
	teleport_animation_player.play("Teleport")
