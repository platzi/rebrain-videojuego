extends Node

signal open_scripting

func _ready() -> void:
	pass


func open_scripting(target_position) -> void:
	emit_signal("open_scripting", target_position)
