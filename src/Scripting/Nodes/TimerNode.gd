tool

extends ScriptingNode

onready var timer_sb = $MarginContainer2/HBoxContainer/TimerSB


func _ready():
	type = "TIMER"
	_set_params(_params)


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		timer_sb.value = params[0]


func _get_params() -> Array:
	return [
		timer_sb.value
	]
