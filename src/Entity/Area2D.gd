extends Area2D


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


func _on_mouse_entered() -> void:
	get_parent().get_node("Sprite").material.set_shader_param("blink", true)


func _on_mouse_exited() -> void:
	get_parent().get_node("Sprite").material.set_shader_param("blink", false)
