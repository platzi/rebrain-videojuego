tool


extends Area2D


export(Shape2D) var shape_2d setget _set_shape_2d


onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D


var parent : Entity
var on_mouse = false
var global_scripting_mode = false

func _ready() -> void:
	parent = get_parent()
	Globals.connect("scripting_toggled", self, "_on_scripting_toggled")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	_set_shape_2d(shape_2d)


func _input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton and _event.button_index == BUTTON_LEFT and _event.pressed and Globals.scripting_mode and !parent.blocked:
		Globals.open_scripting(parent)


func _on_mouse_entered() -> void:
	on_mouse = true
	if Globals.scripting_mode:
		global_scripting_mode = true
		parent.get_node("Sprite").material.set_shader_param("blink", true)
		if parent.has_node("HairSprite"):
			parent.get_node("HairSprite").material.set_shader_param("blink", true)


func _on_mouse_exited() -> void:
	on_mouse = false
	parent.get_node("Sprite").material.set_shader_param("blink", false)
	if parent.has_node("HairSprite"):
		parent.get_node("HairSprite").material.set_shader_param("blink", false)


func _set_shape_2d(new_value : Shape2D) -> void:
	shape_2d = new_value
	if collision_shape_2d:
		collision_shape_2d.shape = shape_2d


func _on_scripting_toggled() -> void:
	if Globals.scripting_mode and parent.blocked:
		parent.get_node("Sprite").material.set_shader_param("blocked", true)
		if parent.has_node("HairSprite"):
			parent.get_node("HairSprite").material.set_shader_param("blocked", true)
	else:
		parent.get_node("Sprite").material.set_shader_param("blocked", false)
		if parent.has_node("HairSprite"):
			parent.get_node("HairSprite").material.set_shader_param("blocked", false)
