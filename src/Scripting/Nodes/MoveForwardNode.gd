tool

extends ScriptingNode

onready var timer_sb : SpinBox = $MarginContainer2/HBoxContainer/TimerSB


func _ready():
	type = "MOVE_FORWARD"
	_set_params(_params)
	_check_disabled()


func _check_disabled() -> void:
	if disabled:
		timer_sb.editable = false
	else:
		timer_sb.editable = true


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		timer_sb.value = params[0]


func _get_params() -> Array:
	return [
		timer_sb.value
	]

