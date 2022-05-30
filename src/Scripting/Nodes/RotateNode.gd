tool

extends ScriptingNode

onready var direction_ob : OptionButton = $MarginContainer2/HBoxContainer/DirectionOB


func _ready():
	type = "ROTATE"
	_set_params(_params)


func _check_disabled() -> void:
	if disabled:
		direction_ob.disabled = true
	else:
		direction_ob.disabled = false


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		direction_ob.selected = params[0]


func _get_params() -> Array:
	return [
		direction_ob.selected
	]
