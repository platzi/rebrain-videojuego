extends Node

const DEBUG := true

signal open_scripting
signal trigger_global
signal show_game_over
signal update_life
signal scripting_toggled
signal scripting_abort
signal scripting_node_added
signal scripting_node_connection
signal screenshake
signal screenshake_finished
signal node_info_pressed

var scripting_mode := false
var disable_inputs := false
var disable_scripting := false
var player_name := ""
var is_game_paused := false
var is_game_over := false
var scripting_area_hover : ScriptingArea


func _ready() -> void:
	pass


func open_scripting(entity : Entity) -> void:
	emit_signal("open_scripting", entity)


func emit_signal_trigger(tag : String) -> void:
	emit_signal("trigger_global", tag)


func emit_show_game_over() -> void:
	emit_signal("show_game_over")
	is_game_over = true


func set_player_name(pname : String) -> void:
	player_name = pname


func emit_update_life(life : int) -> void:
	emit_signal("update_life", life)


func set_pause_game(pause : bool) -> void:
	is_game_paused = pause


func reset_is_game_over() -> void:
	is_game_over = false


func screenshake(time : float, ammount : float) -> void:
	emit_signal("screenshake", time, ammount)
