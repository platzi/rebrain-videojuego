tool


extends Area2D


signal hit


export(Shape2D) var shape setget _set_shape


onready var collision_shape_2d = $CollisionShape2D


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	_set_shape(shape)


func _on_area_entered(area : Area2D) -> void:
	if area.get_parent() != get_parent() and area.is_in_group("HurtBox"):
		emit_signal("hit")


func _set_shape(new_value : Shape2D) -> void:
	shape = new_value
	if collision_shape_2d:
		collision_shape_2d.shape = shape
