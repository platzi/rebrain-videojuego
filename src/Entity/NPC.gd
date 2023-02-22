tool


extends Entity


const HAIR_STYLES = [
	preload("res://assets/images/player/hair_01.png"),
	preload("res://assets/images/player/hair_02.png"),
	preload("res://assets/images/player/hair_03.png"),
	preload("res://assets/images/player/hair_04.png"),
	null
]


export(int, "Estilo 1", "Estilo 2", "Estilo 3", "Estilo 4", "Estilo 5") var hair_style setget _set_hair_style
export(Color) var hair_color setget _set_hair_color
export(Color) var skin_color setget _set_skin_color
export(Color) var shirt_color setget _set_shirt_color
export(Color) var pants_color setget _set_pants_color
export(Color) var shoes_color setget _set_shoes_color


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var hair_sprite := $HairSprite as Sprite


func _ready() -> void:
	_update_avatar()
	if Engine.editor_hint:
		set_process(false)
		_process(0.0)


func _process(_delta : float) -> void:
	if speed != 0.0:
		if direction == 0.0 || direction == 360.0:
			animation_player.play("MoveRight")
		elif direction == 90.0:
			animation_player.play("MoveDown")
		elif direction == 180.0:
			animation_player.play("MoveLeft")
		elif direction == 270.0:
			animation_player.play("MoveUp")
	else:
		if direction == 0.0 || direction == 360.0:
			animation_player.play("IdleRight")
		elif direction == 90.0:
			animation_player.play("IdleDown")
		elif direction == 180.0:
			animation_player.play("IdleLeft")
		elif direction == 270.0:
			animation_player.play("IdleUp")


func _update_avatar() -> void:
	if !sprite or !hair_sprite:
		return
	hair_sprite.texture = HAIR_STYLES[hair_style]
	hair_sprite.material.set_shader_param("HAIR_COLOR", hair_color)
	sprite.material.set_shader_param("SKIN_COLOR", skin_color)
	sprite.material.set_shader_param("SHIRT_COLOR", shirt_color)
	sprite.material.set_shader_param("PANTS_COLOR", pants_color)
	sprite.material.set_shader_param("SHOES_COLOR", shoes_color)


func _set_hair_style(new_value : int) -> void:
	hair_style  = new_value
	_update_avatar()


func _set_hair_color(new_value : Color) -> void:
	hair_color = new_value
	_update_avatar()


func _set_skin_color(new_value : Color) -> void:
	skin_color = new_value
	_update_avatar()


func _set_shirt_color(new_value : Color) -> void:
	shirt_color = new_value
	_update_avatar()


func _set_pants_color(new_value : Color) -> void:
	pants_color = new_value
	_update_avatar()


func _set_shoes_color(new_value : Color) -> void:
	shoes_color = new_value
	_update_avatar()
