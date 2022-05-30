tool

extends ScriptingNode

onready var entites_ob : OptionButton = $MarginContainer3/HBoxContainer/EntitiesOB

func _ready() -> void:
	type = "COMPARE_ENTITY"
	_set_params(_params)
	_check_disabled()


func _check_disabled() -> void:
	if disabled:
		entites_ob.disabled = true
	else:
		entites_ob.disabled = false


func _set_params(params : Array) -> void:
	if _params.size() > 0:
		entites_ob.selected = params[0]


func _get_params() -> Array:
	return [
		entites_ob.selected
	]
