tool

extends ScriptingNode

onready var entites_ob : OptionButton = $MarginContainer3/HBoxContainer/EntitiesOB

var entity := ""

func _ready() -> void:
	type = "COMPARE_ENTITY"


func _set_params(params : Array) -> void:
	entites_ob.selected = params[0]


func _get_params() -> Array:
	return [
		entites_ob.selected
	]
