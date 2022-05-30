extends Node

const DEBUG := true

signal open_scripting
signal trigger_global
signal show_game_over
signal update_life
signal scripting_toggled
signal scripting_abort

var scripting_mode := false
var disable_inputs := false
var disable_scripting := false
var player_name := ""
var is_game_paused := false
var is_game_over := false


func _ready() -> void:
	pass


func open_scripting(entity : Entity) -> void:
	emit_signal("open_scripting", entity)


func emit_signal_trigger(tag : String) -> void:
	emit_signal("trigger_global", tag)


func emit_show_game_over() -> void:
	emit_signal("show_game_over")
	is_game_over = true


func set_player_name(player_name : String) -> void:
	self.player_name = player_name


func emit_update_life(life : int) -> void:
	emit_signal("update_life", life)


func set_last_level(last_level) -> void:
	var config = ConfigFile.new()
	var err = config.load("user://re_brain_data.cfg")
	if err != OK:
		return
	config.set_value("Player", "last_level", last_level)
	config.save("user://re_brain_data.cfg")


func set_pause_game(pause : bool) -> void:
	is_game_paused = pause


func reset_is_game_over() -> void:
	is_game_over = false
