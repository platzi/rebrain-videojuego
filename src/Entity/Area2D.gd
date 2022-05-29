extends Area2D

var on_mouse = false
var global_scripting_mode = false

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _input_event(viewport, event, shape_idx):
	if (
		event is InputEventMouseButton 
		and event.button_index == BUTTON_LEFT
		and event.pressed
		and Globals.scripting_mode
	):
		Globals.open_scripting(get_parent())


func _process(delta):
	if Globals.scripting_mode and on_mouse:
		_on_mouse_entered()
	elif global_scripting_mode and on_mouse:
		global_scripting_mode = false
		get_parent().get_node("Sprite").material.set_shader_param("blink", false)


func _on_mouse_entered() -> void:
	on_mouse = true
	if Globals.scripting_mode:
		get_parent().get_node("Sprite").material.set_shader_param("blink", true)
		global_scripting_mode = true

func _on_mouse_exited() -> void:
	on_mouse = false
	get_parent().get_node("Sprite").material.set_shader_param("blink", false)
