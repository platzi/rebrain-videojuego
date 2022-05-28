extends CanvasLayer

var node_scene_list := {
	UPDATE = preload("res://src/Scripting/Nodes/UpdateNode.tscn"),
	MOVE_FORWARD = preload("res://src/Scripting/Nodes/MoveForwardNode.tscn"),
	ROTATE = preload("res://src/Scripting/Nodes/RotateNode.tscn"),
	TIMER = preload("res://src/Scripting/Nodes/TimerNode.tscn"),
	SHOOT = preload("res://src/Scripting/Nodes/ShootNode.tscn"),
	MESSAGE = preload("res://src/Scripting/Nodes/MessageNode.tscn"),
	COLLISION = preload("res://src/Scripting/Nodes/CollisionNode.tscn"),
	COMPARE_ENTITY = preload("res://src/Scripting/Nodes/CompareEntityNode.tscn"),
}

var is_open := true

onready var scripting_container : Control = $ScriptingContainer
onready var node_searcher := $ScriptingContainer/NodeSearcher
onready var scripting_graph := $ScriptingContainer/ScriptingGraph
onready var animation_player : AnimationPlayer = $AnimationPlayer

var brain := {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}

func _ready() -> void:
	node_searcher.connect("node_selected", self, "_create_new_node")
	load_nodes(brain)


func _input(event : InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed():
		if event.button_mask == BUTTON_RIGHT:
			node_searcher.popup(Rect2(event.position.x, event.position.y, 200, 200))
		elif event.button_mask == BUTTON_LEFT:
			toggle(scripting_container.get_global_mouse_position())
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_A:
			print(scripting_graph.get_connection_list())
		elif event.scancode == KEY_O:
			toggle(Vector2(100.0, 100.0))


func toggle(target_position : Vector2) -> void:
	if is_open:
		close(target_position)
	else:
		open(target_position)


func open(target_position : Vector2) -> void:
	is_open = true
	animation_player.play("Open")
	var open_anim := animation_player.get_animation("Open")
	var position_x_track := open_anim.find_track("ScriptingContainer:rect_position:x")
	var position_y_track := open_anim.find_track("ScriptingContainer:rect_position:y")
	var position_x_values = open_anim.track_get_key_value(position_x_track, 0)
	var position_y_values = open_anim.track_get_key_value(position_y_track, 0)
	position_x_values[0] = target_position.x
	position_y_values[0] = target_position.y
	open_anim.track_set_key_value(position_x_track, 0, position_x_values)
	open_anim.track_set_key_value(position_y_track, 0, position_y_values)


func close(target_position : Vector2) -> void:
	is_open = false
	animation_player.play("Close")
	var close_anim := animation_player.get_animation("Close")
	var position_x_track := close_anim.find_track("ScriptingContainer:rect_position:x")
	var position_y_track := close_anim.find_track("ScriptingContainer:rect_position:y")
	var position_x_values = close_anim.track_get_key_value(position_x_track, 1)
	var position_y_values = close_anim.track_get_key_value(position_y_track, 1)
	position_x_values[0] = target_position.x
	position_y_values[0] = target_position.y
	close_anim.track_set_key_value(position_x_track, 1, position_x_values)
	close_anim.track_set_key_value(position_y_track, 1, position_y_values)


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


func _create_new_node(node_type : String) -> void:
	var mousePos := scripting_container.get_local_mouse_position()
	var inst : ScriptingNode = node_scene_list[node_type].instance()
	inst.offset = mousePos + scripting_graph.scroll_offset
	scripting_graph.add_child(inst)
	node_searcher.hide()
