extends Control

var node_scene_list := {
	UPDATE = preload("res://src/Scripting/Nodes/UpdateNode.tscn"),
	MOVE_FORWARD = preload("res://src/Scripting/Nodes/MoveForwardNode.tscn"),
	ROTATE = preload("res://src/Scripting/Nodes/RotateNode.tscn"),
	TIMER = preload("res://src/Scripting/Nodes/TimerNode.tscn"),
	SHOOT = preload("res://src/Scripting/Nodes/ShootNode.tscn"),
	MESSAGE = preload("res://src/Scripting/Nodes/MessageNode.tscn"),
}

onready var node_searcher := $NodeSearcher
onready var scripting_graph := $ScriptingGraph

var brain := {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}

func _ready() -> void:
	node_searcher.connect("node_selected", self, "_create_new_node")
	load_nodes(brain)


func load_nodes(nodes) -> void:
	# Instance nodes
	for key in nodes:
		var node = nodes[key]
		var inst : ScriptingNode = node_scene_list[node.type].instance()
		inst.offset.x = node.position[0]
		inst.offset.y = node.position[1]
		print(node.params)
		inst.set_params(node.params)
		scripting_graph.add_child(inst)
		node_searcher.hide()
		nodes[key].instance = inst
	# Make connections
	for key in nodes:
		var node = nodes[key]
		var from = node.instance
		for connection in node.connections:
			var to = nodes[connection.to].instance
			scripting_graph.connect_node(from.name, connection.from_port, to.name, connection.to_port)


func _input(event : InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_mask == BUTTON_RIGHT:
		node_searcher.popup(Rect2(event.position.x, event.position.y, 200, 200))
	elif event is InputEventKey and event.is_pressed() and event.scancode == KEY_A:
		print(scripting_graph.get_connection_list())


func _create_new_node(node_type : String) -> void:
	var mousePos := get_local_mouse_position()
	var inst : ScriptingNode = node_scene_list[node_type].instance()
	inst.offset = mousePos + scripting_graph.scroll_offset
	scripting_graph.add_child(inst)
	node_searcher.hide()
