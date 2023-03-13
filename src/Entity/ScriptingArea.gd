tool


extends Area2D


class_name ScriptingArea


export(Shape2D) var shape_2d setget _set_shape_2d


onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D


var parent : Entity
var on_mouse = false


func _ready() -> void:
	parent = get_parent()
	Globals.connect("scripting_toggled", self, "_on_scripting_toggled")
	connect("mouse_exited", self, "_on_mouse_exited")
	_set_shape_2d(shape_2d)


func _input_event(_viewport : Object, _event : InputEvent, _shape_idx : int):
	if _event is InputEventMouseMotion:
		_check_hover()
	elif _event is InputEventMouseButton and _event.button_index == BUTTON_LEFT and _event.pressed and Globals.scripting_mode and on_mouse and !parent.blocked:
		Globals.open_scripting(parent)


func _check_hover() -> void:
	on_mouse = false
	if parent.blocked:
		_deactivate_hover_effect()
		return
	if Globals.scripting_area_hover == null or Globals.scripting_area_hover == self or Globals.scripting_area_hover.parent.position.y < parent.position.y or Globals.scripting_area_hover.parent.is_in_group("Unsorted"):
		Globals.scripting_area_hover = self
		on_mouse = true
	if Globals.scripting_mode and on_mouse:
		_activate_hover_effect()
	else:
		_deactivate_hover_effect()


func _on_mouse_exited() -> void:
	on_mouse = false
	_deactivate_hover_effect()
	if Globals.scripting_area_hover == self:
		Globals.scripting_area_hover = null
	if Globals.scripting_area_hover == self:
		Globals.scripting_area_hover = null


func _activate_hover_effect() -> void:
	parent.get_node("Sprite").material.set_shader_param("blink", true)
	if parent.has_node("HairSprite"):
		parent.get_node("HairSprite").material.set_shader_param("blink", true)


func _deactivate_hover_effect() -> void:
	parent.get_node("Sprite").material.set_shader_param("blink", false)
	if parent.has_node("HairSprite"):
		parent.get_node("HairSprite").material.set_shader_param("blink", false)


func _set_shape_2d(new_value : Shape2D) -> void:
	shape_2d = new_value
	if collision_shape_2d:
		collision_shape_2d.shape = shape_2d


func _on_scripting_toggled() -> void:
	if Globals.scripting_mode and parent.blocked:
		if parent.has_node("Sprite"):
			parent.get_node("Sprite").material.set_shader_param("blocked", true)
		if parent.has_node("HairSprite"):
			parent.get_node("HairSprite").material.set_shader_param("blocked", true)
		if parent.has_node("StudentSprite"):
			parent.get_node("StudentSprite").material.set_shader_param("blocked", true)
			parent.get_node("StudentSprite/HairSprite").material.set_shader_param("blocked", true)
	else:
		if parent.has_node("Sprite"):
			parent.get_node("Sprite").material.set_shader_param("blocked", false)
		if parent.has_node("HairSprite"):
			parent.get_node("HairSprite").material.set_shader_param("blocked", false)
		if parent.has_node("StudentSprite"):
			parent.get_node("StudentSprite").material.set_shader_param("blocked", false)
			parent.get_node("StudentSprite/HairSprite").material.set_shader_param("blocked", false)
