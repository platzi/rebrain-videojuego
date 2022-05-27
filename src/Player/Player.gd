extends KinematicBody2D


const MAX_SPEED = 200
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var life = 3
var inmunity = false
var player_name = ""


onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var inmunity_timer := $InmunityTimer
onready var hair_sprite := $HairSprite
onready var customization := $Customization


func remove_inmunity() -> void:
	inmunity = false


func hurt(move_vector : Vector2) -> void:
	if not inmunity:
		inmunity = true
		life -= 1
		position += move_vector * 15
		inmunity_timer.start(1)


func change_hair(hair : Texture) -> void:
	hair_sprite.texture = hair


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



func _ready() -> void:
	inmunity_timer.connect("timeout", self, "remove_inmunity")
	customization.connect("change_hair", self, "change_hair")
	customization.connect("change_skin_color", self, "change_skin_color")
	customization.connect("change_shirt", self, "change_shirt")
	customization.connect("change_pants", self, "change_pants")
	customization.connect("change_shoes", self, "change_shoes")
	customization.connect("change_player_name", self, "change_player_name")
	change_skin_color(customization.skin_colors[customization.current_skin_color])
	change_shirt(customization.clothes_colors[customization.current_shirt])
	change_pants(customization.clothes_colors[customization.current_pants])
	change_shoes(customization.clothes_colors[customization.current_shoes])


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
				hurt(-input_vector)
			if collision.collider.is_in_group("Entity"):
				hurt(-input_vector)
	else:
		animation_state.travel("Idle")

