tool

extends ScriptingNode

onready var string_le : LineEdit = $MarginContainer4/HBoxContainer/StringLE

func _ready() -> void:
	type = "COMPARE_STRING"
	_set_params(_params)


func _check_disabled() -> void:
	if disabled:
		string_le.editable = false
	else:
		string_le.editable = true


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		string_le.text = params[0]


func _get_params() -> Array:
	return [
		string_le.text
	]
