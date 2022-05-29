extends Node

signal open_scripting

var scripting_mode := false

func _ready() -> void:
	pass


func open_scripting(entity : Entity) -> void:
	emit_signal("open_scripting", entity)
