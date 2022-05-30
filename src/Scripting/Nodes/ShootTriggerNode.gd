tool

extends ScriptingNode

onready var message_le : LineEdit = $MarginContainer2/MessageLE


func _ready():
	type = "SHOOT_TRIGGER"
	_set_params(_params)


func _check_disabled() -> void:
	if disabled:
		message_le.editable = false
	else:
		message_le.editable = true


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		message_le.text = params[0]


func _get_params() -> Array:
	return [
		message_le.text
	]
