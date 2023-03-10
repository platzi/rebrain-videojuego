tool


extends Node


class_name EventHint


export(String) var title
export(Array, Resource) var hints setget _set_hints


func _set_hints(new_value : Array):
	hints.resize(new_value.size())
	hints = new_value
	for i in hints.size():
		if not hints[i]:
			hints[i] = HintResource.new()
			hints[i].resource_name = "Hint"
