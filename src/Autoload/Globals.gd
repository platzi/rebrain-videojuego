extends Node

signal open_scripting
signal trigger_global
signal show_game_over

var scripting_mode := false
var disable_inputs := false
var player_name := ""

func _ready() -> void:
	pass


func open_scripting(entity : Entity) -> void:
	emit_signal("open_scripting", entity)


func emit_signal_trigger(tag : String) -> void:
	emit_signal("trigger_global", tag)


func emit_show_game_over() -> void:
	emit_signal("show_game_over")


func set_player_name(player_name : String) -> void:
	self.player_name = player_name
