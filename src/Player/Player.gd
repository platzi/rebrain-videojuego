extends KinematicBody2D


const MAX_SPEED = 200
var speed = 100
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var inmunity = false
var inmunity_time = 1
var player_name = ""
var is_customizing = true


onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var inmunity_timer := $InmunityTimer
onready var hair_sprite := $HairSprite
onready var customization := $Customization


func _ready() -> void:
	inmunity_timer.connect("timeout", self, "remove_inmunity")
	customization.connect("change_hair", self, "change_hair")
	customization.connect("change_hair_color", self, "change_hair_color")
	customization.connect("change_skin_color", self, "change_skin_color")
	customization.connect("change_shirt", self, "change_shirt")
	customization.connect("change_pants", self, "change_pants")
	customization.connect("change_shoes", self, "change_shoes")
	customization.connect("change_player_name", self, "change_player_name")
	customization.connect("ended_customizing", self, "ended_customizing")
	change_hair(customization.all_hairs[customization.current_hair])
	change_hair_color(customization.hair_colors[customization.current_hair_color])
	change_skin_color(customization.skin_colors[customization.current_skin_color])
	change_shirt(customization.clothes_colors[customization.current_shirt])
	change_pants(customization.clothes_colors[customization.current_pants])
	change_shoes(customization.clothes_colors[customization.current_shoes])


func _physics_process(delta : float) -> void:
	if !Globals.disable_inputs:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
	else:
		input_vector = Vector2.ZERO
	if not is_customizing:
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
		Globals.emit_update_life(life)
	if life < 1:
		queue_free()
		Globals.emit_show_game_over()


func change_hair(hair : Texture) -> void:
	hair_sprite.texture = hair


func change_hair_color(color : Color) -> void:
	$HairSprite.material.set_shader_param("HAIR_COLOR", color)


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


func ended_customizing() -> void:
	is_customizing = false
