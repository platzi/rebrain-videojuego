extends Control

var scriptingNodeScn := preload("res://src/Scripting/ScriptingNode.tscn")

onready var node_searcher := $NodeSearcher
onready var scriptingGraph := $ScriptingGraph

func _ready() -> void:
	node_searcher.connect("node_selected", self, "_create_new_node")


func _input(event : InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_mask == BUTTON_RIGHT:
		node_searcher.popup(Rect2(event.position.x, event.position.y, 200, 200))


func _create_new_node(node_type : String) -> void:
	var mousePos := get_local_mouse_position()
	var inst := scriptingNodeScn.instance()
	inst.type = node_type
	inst.offset = mousePos + scriptingGraph.scroll_offset
	scriptingGraph.add_child(inst)
	node_searcher.hide()
