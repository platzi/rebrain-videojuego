extends Node

signal open_scripting
signal trigger_global

var scripting_mode := false
var disable_inputs := false

func _ready() -> void:
	pass


func open_scripting(entity : Entity) -> void:
	emit_signal("open_scripting", entity)


func emit_signal_trigger(tag : String) -> void:
	emit_signal("trigger_global", tag)
