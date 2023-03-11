extends KinematicBody2D


var direction := 0.0
var speed := 144.0
var life = 3
var move_towards_vector := Vector2.ZERO
var is_moving_towards = false
var input_vector = Vector2.ZERO

onready var audio_stream_player := $AudioStreamPlayer2D
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var teleport_animation_player := $TeleportAnimationPlayer
onready var hair_sprite := $Sprite/HairSprite
onready var sprite := $Sprite
onready var hurt_box := $HurtBox

var knockback_velocity = Vector2.ZERO

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


func _process(_delta : float) -> void:
	if input_vector != Vector2.ZERO:
		if direction >= 315.0 or direction <= 45.0:
			animation_player.play("MoveRight")
		elif direction > 45.0 and direction < 135:
			animation_player.play("MoveDown")
		elif direction >= 135.0 and direction <= 225:
			animation_player.play("MoveLeft")
		elif direction > 225.0 and direction < 315:
			animation_player.play("MoveUp")
	else:
		if direction >= 315.0 or direction <= 45.0:
			animation_player.play("IdleRight")
		elif direction > 45.0 and direction < 135:
			animation_player.play("IdleDown")
		elif direction >= 135.0 and direction <= 225:
			animation_player.play("IdleLeft")
		elif direction > 225.0 and direction < 315:
			animation_player.play("IdleUp")


func _physics_process(delta : float) -> void:
	if knockback_velocity != Vector2.ZERO:
		var knockback_direction = knockback_velocity.normalized()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 10000.0)
		if _is_place_walkable(knockback_direction.x * 16.0, knockback_direction.y * 16.0):
			move_and_slide(knockback_velocity)
		return
	var movement_vector = Vector2.ZERO
	input_vector = Vector2.ZERO
	if !Globals.disable_inputs:
		if Input.is_action_pressed("move_right"):
			input_vector.x = 1.0
			if _is_place_walkable(16.0, 0.0):
				movement_vector.x = 1.0
		elif Input.is_action_pressed("move_left"):
			input_vector.x = -1.0
			if _is_place_walkable(-16.0, 0.0):
				movement_vector.x = -1.0
		if Input.is_action_pressed("move_up"):
			input_vector.y = -1.0
			if _is_place_walkable(0.0, -16.0):
				movement_vector.y = -1.0
		elif Input.is_action_pressed("move_down"):
			input_vector.y = 1.0
			if _is_place_walkable(0.0, 16.0):
				movement_vector.y = 1.0
		input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		direction = fmod(round(rad2deg(input_vector.angle())) + 360.0, 360.0)
	if movement_vector != Vector2.ZERO:
		movement_vector = movement_vector.normalized()
		move_and_slide(movement_vector * speed)


func _is_place_walkable(x : float, y : float) -> bool:
	if len(get_world_2d().direct_space_state.intersect_point(position + Vector2(x, y), 1, [self], 16, true, true)) > 0:
		return true
	return false


func hurt(knockback_direction : Vector2) -> void:
	life -= 1
	knockback_velocity = knockback_direction * speed * 8
	Globals.emit_update_life(life)
	Globals.screenshake(0.2, 5.0)
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
