extends Area2D

var on_mouse = false
var global_scripting_mode = false

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _input_event(_viewport, _event, _shape_idx):
	if (
		_event is InputEventMouseButton 
		and _event.button_index == BUTTON_LEFT
		and _event.pressed
		and Globals.scripting_mode
	):
		Globals.open_scripting(get_parent())


func _process(_delta : float):
	if Globals.scripting_mode and on_mouse:
		_on_mouse_entered()
	elif global_scripting_mode and on_mouse:
		global_scripting_mode = false
		get_parent().get_node("Sprite").material.set_shader_param("blink", false)


func _on_mouse_entered() -> void:
	on_mouse = true
	if Globals.scripting_mode:
		global_scripting_mode = true
		get_parent().get_node("Sprite").material.set_shader_param("blink", true)
		if get_parent().has_node("HairSprite"):
			get_parent().get_node("HairSprite").material.set_shader_param("blink", true)


func _on_mouse_exited() -> void:
	on_mouse = false
	get_parent().get_node("Sprite").material.set_shader_param("blink", false)
	if get_parent().has_node("HairSprite"):
		get_parent().get_node("HairSprite").material.set_shader_param("blink", false)
