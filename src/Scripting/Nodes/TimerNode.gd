tool

extends ScriptingNode

onready var timer_sb = $MarginContainer2/HBoxContainer/TimerSB


func _ready():
	type = "TIMER"


func _set_params(params : Array) -> void:
	timer_sb.value = params[0]


func _get_params() -> Array:
	return [
		timer_sb.value
	]
