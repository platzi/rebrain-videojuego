tool


extends Entity


signal unlocked
signal teleported


export(int, "Estilo 1", "Estilo 2", "Estilo 3", "Estilo 4", "Estilo 5") var hair_style setget _set_hair_style
export(Color) var hair_color setget _set_hair_color
export(Color) var skin_color setget _set_skin_color
export(Color) var shirt_color setget _set_shirt_color
export(Color) var pants_color setget _set_pants_color
export(Color) var shoes_color setget _set_shoes_color
export(bool) var random_student setget _set_random_student


onready var student_sprite := $StudentSprite as Sprite
onready var hair_sprite := $StudentSprite/HairSprite as Sprite
onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	animation_player.play("RESET")
	_update_student()


func unlock() -> void:
	animation_player.play("Unlock")


func teleport() -> void:
	animation_player.play("Teleport")


func _update_student() -> void:
	if !student_sprite or !hair_sprite:
		return
	hair_sprite.texture = Customization.HAIR_STYLES[hair_style]
	hair_sprite.material.set_shader_param("HAIR_COLOR", hair_color)
	student_sprite.material.set_shader_param("SKIN_COLOR", skin_color)
	student_sprite.material.set_shader_param("SHIRT_COLOR", shirt_color)
	student_sprite.material.set_shader_param("PANTS_COLOR", pants_color)
	student_sprite.material.set_shader_param("SHOES_COLOR", shoes_color)


func _set_hair_style(new_value : int) -> void:
	hair_style  = new_value
	_update_student()


func _set_hair_color(new_value : Color) -> void:
	hair_color = new_value
	_update_student()


func _set_skin_color(new_value : Color) -> void:
	skin_color = new_value
	_update_student()


func _set_shirt_color(new_value : Color) -> void:
	shirt_color = new_value
	_update_student()


func _set_pants_color(new_value : Color) -> void:
	pants_color = new_value
	_update_student()


func _set_shoes_color(new_value : Color) -> void:
	shoes_color = new_value
	_update_student()


func _set_random_student(new_value : bool) -> void:
	hair_style = randi() % Customization.HAIR_STYLES.size()
	hair_color = Customization.HAIR_COLORS[randi() % Customization.HAIR_COLORS.size()]
	skin_color = Customization.SKIN_COLORS[randi() % Customization.SKIN_COLORS.size()]
	shirt_color = Customization.CLOTHES_COLOR[randi() % Customization.CLOTHES_COLOR.size()]
	pants_color = Customization.CLOTHES_COLOR[randi() % Customization.CLOTHES_COLOR.size()]
	shoes_color = Customization.CLOTHES_COLOR[randi() % Customization.CLOTHES_COLOR.size()]
	_update_student()
	property_list_changed_notify()
