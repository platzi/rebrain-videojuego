tool

extends Area2D

export(Shape2D) var collision_shape setget _set_collision_shape
export(float) var zoom_level = 1.0 setget _set_zoom_level

onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D

var _is_ready


func _ready() -> void:
	_is_ready = true
	_set_collision_shape(collision_shape)


func _set_collision_shape(new_value : Shape2D) -> void:
	collision_shape = new_value
	if _is_ready:
		collision_shape_2d.shape = collision_shape

func _set_zoom_level(new_value : float) -> void:
	zoom_level = new_value
