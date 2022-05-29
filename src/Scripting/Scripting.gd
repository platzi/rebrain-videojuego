extends Control

var node_scene_list := {
	UPDATE = preload("res://src/Scripting/Nodes/UpdateNode.tscn"),
	COLLISION = preload("res://src/Scripting/Nodes/CollisionNode.tscn"),
	TRIGGER = preload("res://src/Scripting/Nodes/TriggerNode.tscn"),
	MOVE_FORWARD = preload("res://src/Scripting/Nodes/MoveForwardNode.tscn"),
	ROTATE = preload("res://src/Scripting/Nodes/RotateNode.tscn"),
	TIMER = preload("res://src/Scripting/Nodes/TimerNode.tscn"),
	SHOOT = preload("res://src/Scripting/Nodes/ShootNode.tscn"),
	EXPLODE = preload("res://src/Scripting/Nodes/ExplodeNode.tscn"),
	MESSAGE = preload("res://src/Scripting/Nodes/MessageNode.tscn"),
	COMPARE_ENTITY = preload("res://src/Scripting/Nodes/CompareEntityNode.tscn"),
	COMPARE_STRING = preload("res://src/Scripting/Nodes/CompareStringNode.tscn"),
}

var is_open := true

onready var node_searcher := $NodeSearcher
onready var scripting_graph : GraphEdit = $MarginContainer/HBoxContainer/ScriptingGraph
onready var animation_player : AnimationPlayer = $AnimationPlayer

onready var save_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/SaveBtn
onready var restore_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/RestoreBtn
onready var cancel_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/CancelBtn

var brain := {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}

func _ready() -> void:
	Globals.connect("open_scripting", self, "open")
	node_searcher.connect("node_selected", self, "_create_new_node")
	scripting_graph.connect("popup_request", self, "open_node_searcher")
	save_btn.connect("pressed", self, "on_SaveBtn_pressed")
	restore_btn.connect("pressed", self, "on_RestoreBtn_pressed")
	cancel_btn.connect("pressed", self, "on_CancelBtn_pressed")
	load_nodes(brain)


func _input(event : InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed():
		if event.button_mask == BUTTON_LEFT:
			pass
#			toggle(get_global_mouse_position())
	elif event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_A:
			print(scripting_graph.get_connection_list())
		elif event.scancode == KEY_O:
			toggle(Vector2(100.0, 100.0))


func open_node_searcher(open_position : Vector2) -> void:
	node_searcher.popup(Rect2(open_position.x, open_position.y, 200, 200))


func toggle(target_position : Vector2) -> void:
	if is_open:
		close(target_position)
	else:
		open(target_position)


func open(target_position : Vector2) -> void:
	is_open = true
	animation_player.play("Open")
	var open_anim := animation_player.get_animation("Open")
	var position_x_track := open_anim.find_track("MarginContainer:rect_position:x")
	var position_y_track := open_anim.find_track("MarginContainer:rect_position:y")
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
	var position_x_track := close_anim.find_track("MarginContainer:rect_position:x")
	var position_y_track := close_anim.find_track("MarginContainer:rect_position:y")
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
	var mousePos := scripting_graph.get_local_mouse_position()
	var inst : ScriptingNode = node_scene_list[node_type].instance()
	inst.offset = mousePos + scripting_graph.scroll_offset
	scripting_graph.add_child(inst)
	node_searcher.hide()


func on_SaveBtn_pressed() -> void:
	pass


func on_RestoreBtn_pressed() -> void:
	pass


func on_CancelBtn_pressed() -> void:
	pass
