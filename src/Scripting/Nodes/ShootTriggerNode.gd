tool

extends ScriptingNode

onready var message_le := $MarginContainer2/MessageLE
onready var timer_sb := $MarginContainer3/HBoxContainer/TimerSB


func _ready():
	type = "SHOOT_TRIGGER"
	_set_params(_params)


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		message_le.text = params[0]


func _get_params() -> Array:
	return [
		message_le.text
	]
