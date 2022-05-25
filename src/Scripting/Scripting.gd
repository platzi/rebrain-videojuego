extends Control

var scriptingNodeScn := preload("res://src/Scripting/ScriptingNode.tscn")

onready var nodeSearcher := $NodeSearcher
onready var scriptingGraph := $ScriptingGraph

func _ready() -> void:
	nodeSearcher.connect("node_selected", self, "_create_new_node")

func _input(event : InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_mask == BUTTON_RIGHT:
		nodeSearcher.popup(Rect2(event.position.x, event.position.y, 200, 200))

func _create_new_node(node_type : String) -> void:
	var mousePos := get_local_mouse_position()
	var inst := scriptingNodeScn.instance()
	inst.type = node_type
	inst.offset = mousePos + scriptingGraph.scroll_offset
	scriptingGraph.add_child(inst)
	nodeSearcher.hide()
