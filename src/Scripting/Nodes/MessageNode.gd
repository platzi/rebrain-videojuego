tool

extends ScriptingNode

onready var message_le := $MarginContainer2/MessageLE
onready var timer_sb := $MarginContainer3/HBoxContainer/TimerSB


func _ready():
	type = "MESSAGE"


func _set_params(params : Array) -> void:
	message_le.text = params[0]
	timer_sb.value = params[1]


func _get_params() -> Array:
	return [
		message_le.text,
		timer_sb.value
	]
