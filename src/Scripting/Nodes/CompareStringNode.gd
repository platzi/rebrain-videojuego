tool

extends ScriptingNode

onready var string_le := $MarginContainer4/HBoxContainer/StringLE

var text := ""

func _ready() -> void:
	type = "COMPARE_STRING"
	_set_params(_params)


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		string_le.text = params[0]


func _get_params() -> Array:
	return [
		string_le.text
	]
