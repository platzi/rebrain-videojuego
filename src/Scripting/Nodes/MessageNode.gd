tool

extends ScriptingNode

onready var message_le : LineEdit = $MarginContainer2/MessageLE
onready var timer_sb : SpinBox = $MarginContainer3/HBoxContainer/TimerSB


func _ready():
	type = "MESSAGE"
	_set_params(_params)
	_check_disabled()


func _check_disabled() -> void:
	if disabled:
		timer_sb.editable = false
		message_le.editable = false
	else:
		timer_sb.editable = true
		message_le.editable = true


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		message_le.text = params[0]
		timer_sb.value = params[1]


func _get_params() -> Array:
	return [
		message_le.text,
		timer_sb.value
	]
