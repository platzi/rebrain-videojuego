extends Control

var node_scene_list := {
	# EVENTS
	UPDATE = preload("res://src/Scripting/Nodes/UpdateNode.tscn"),
	COLLISION = preload("res://src/Scripting/Nodes/CollisionNode.tscn"),
	TRIGGER = preload("res://src/Scripting/Nodes/TriggerNode.tscn"),
	PRESSED = preload("res://src/Scripting/Nodes/PressedNode.tscn"),
	RELEASED = preload("res://src/Scripting/Nodes/ReleasedNode.tscn"),
	# ACTIONS
	MOVE_FORWARD = preload("res://src/Scripting/Nodes/MoveForwardNode.tscn"),
	ROTATE_LEFT = preload("res://src/Scripting/Nodes/RotateLeftNode.tscn"),
	ROTATE_RIGHT = preload("res://src/Scripting/Nodes/RotateRightNode.tscn"),
	TIMER = preload("res://src/Scripting/Nodes/TimerNode.tscn"),
	SHOOT = preload("res://src/Scripting/Nodes/ShootNode.tscn"),
	OPEN = preload("res://src/Scripting/Nodes/OpenNode.tscn"),
	CLOSE = preload("res://src/Scripting/Nodes/CloseNode.tscn"),
	SHOOT_TRIGGER = preload("res://src/Scripting/Nodes/ShootTriggerNode.tscn"),
	# LOGIC
	IF = preload("res://src/Scripting/Nodes/IfNode.tscn"),
	AND = preload("res://src/Scripting/Nodes/AndNode.tscn"),
	OR = preload("res://src/Scripting/Nodes/OrNode.tscn"),
	EQUAL = preload("res://src/Scripting/Nodes/EqualNode.tscn"),
	NOT_EQUAL = preload("res://src/Scripting/Nodes/NotEqualNode.tscn"),
	GREATER = preload("res://src/Scripting/Nodes/GreaterNode.tscn"),
	GREATER_EQUAL = preload("res://src/Scripting/Nodes/GreaterEqualNode.tscn"),
	LESS = preload("res://src/Scripting/Nodes/LessNode.tscn"),
	LESS_EQUAL = preload("res://src/Scripting/Nodes/LessEqualNode.tscn"),
	COMPARE_ENTITY = preload("res://src/Scripting/Nodes/CompareEntityNode.tscn"),
	COMPARE_STRING = preload("res://src/Scripting/Nodes/CompareStringNode.tscn"),
	# INPUT
	NUMBER = preload("res://src/Scripting/Nodes/NumberNode.tscn"),
	STRING = preload("res://src/Scripting/Nodes/StringNode.tscn"),
	BOOL = preload("res://src/Scripting/Nodes/BoolNode.tscn"),
	ENTITY = preload("res://src/Scripting/Nodes/EntityNode.tscn"),
	# LOCAL VARIABLES
	POSITION = preload("res://src/Scripting/Nodes/PositionNode.tscn"),
	DIRECTION = preload("res://src/Scripting/Nodes/DirectionNode.tscn"),
}


var is_open := false


onready var node_searcher := $NodeSearcher as PopupPanel
onready var scripting_graph : GraphEdit = $MarginContainer/HBoxContainer/ScriptingGraph
onready var animation_player : AnimationPlayer = $AnimationPlayer

onready var sprite : Sprite = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Sprite
onready var hair_sprite : Sprite = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/HairSprite
onready var save_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/SaveBtn
onready var restore_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/RestoreBtn
onready var cancel_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/CancelBtn

var brain := {}

var _target_entity : Entity
var _open_position : Vector2

func _ready() -> void:
	Globals.connect("open_scripting", self, "open")
	Globals.connect("scripting_abort", self, "abort")
	node_searcher.connect("node_selected", self, "_create_new_node")
	scripting_graph.connect("popup_request", self, "open_node_searcher")
	save_btn.connect("pressed", self, "on_SaveBtn_pressed")
	restore_btn.connect("pressed", self, "on_RestoreBtn_pressed")
	cancel_btn.connect("pressed", self, "on_CancelBtn_pressed")
	load_nodes(brain)


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if !Globals.disable_scripting and event.scancode == KEY_TAB:
			if !Globals.scripting_mode:
				Globals.scripting_mode = true
				get_tree().paused = true
			elif is_open:
					on_SaveBtn_pressed()
			else:
				Globals.scripting_mode = false
				get_tree().paused = false
			Globals.emit_signal("scripting_toggled")
#		elif event.scancode == KEY_A:
#			print(scripting_graph.get_connection_list())


func open_node_searcher(open_position : Vector2) -> void:
	node_searcher.popup(Rect2(open_position.x, open_position.y, 200, 200))


func abort() -> void:
	yield(get_tree(), "idle_frame")
	animation_player.play("RESET")


func open(entity : Entity) -> void:
	_target_entity = entity
	var target_sprite = _target_entity.get_node("Sprite")
	sprite.texture = target_sprite.texture
	sprite.hframes = target_sprite.hframes
	sprite.vframes = target_sprite.vframes
	sprite.frame = target_sprite.frame
	if _target_entity.is_in_group("NPC"):
		sprite.material = target_sprite.material
		var target_hair_sprite = _target_entity.get_node("HairSprite")
		hair_sprite.texture = target_hair_sprite.texture
		hair_sprite.hframes = target_hair_sprite.hframes
		hair_sprite.vframes = target_hair_sprite.vframes
		hair_sprite.frame = target_hair_sprite.frame
		hair_sprite.material = target_hair_sprite.material
	else:
		sprite.material = null
		hair_sprite.material = null
		hair_sprite.visible = false
	node_searcher.blacklist = entity.blacklist
	brain = entity.brain.brain
	load_nodes(brain)
	is_open = true
	animation_player.play("Open")
	var target_position = get_global_mouse_position()
	_open_position = target_position
	var open_anim := animation_player.get_animation("Open")
	var position_x_track := open_anim.find_track("MarginContainer:rect_position:x")
	var position_y_track := open_anim.find_track("MarginContainer:rect_position:y")
	var position_x_values = open_anim.track_get_key_value(position_x_track, 0)
	var position_y_values = open_anim.track_get_key_value(position_y_track, 0)
	position_x_values[0] = target_position.x
	position_y_values[0] = target_position.y
	open_anim.track_set_key_value(position_x_track, 0, position_x_values)
	open_anim.track_set_key_value(position_y_track, 0, position_y_values)
	scripting_graph.scroll_offset = -(scripting_graph.rect_size / 2.0)


func close() -> void:
	is_open = false
	animation_player.play("Close")
	var close_anim := animation_player.get_animation("Close")
	var position_x_track := close_anim.find_track("MarginContainer:rect_position:x")
	var position_y_track := close_anim.find_track("MarginContainer:rect_position:y")
	var position_x_values = close_anim.track_get_key_value(position_x_track, 1)
	var position_y_values = close_anim.track_get_key_value(position_y_track, 1)
	position_x_values[0] = _open_position.x
	position_y_values[0] = _open_position.y
	close_anim.track_set_key_value(position_x_track, 1, position_x_values)
	close_anim.track_set_key_value(position_y_track, 1, position_y_values)


func load_nodes(nodes) -> void:
	scripting_graph.delete_all_nodes()
	# Instance nodes
	for key in nodes:
		var node = nodes[key]
		if !node_scene_list.has(node.type):
			continue
		var inst : ScriptingNode = node_scene_list[node.type].instance()
		inst.offset.x = node.position[0]
		inst.offset.y = node.position[1]
		inst.disabled = node.disabled
		inst.set_inputs(node.inputs)
		inst.set_outputs(node.outputs)
		scripting_graph.add_child(inst)
		nodes[key].instance = inst
	node_searcher.hide()
	# Make connections
	for key in nodes:
		var node = nodes[key]
		if !node.has("instance"):
			continue
		var from = node.instance
		for connection in node.connections_out:
			if !nodes.has(connection.to) or !nodes[connection.to].has("instance"):
				continue
			var to = nodes[connection.to].instance
			scripting_graph.connect_node(from.name, connection.from_port, to.name, connection.to_port)


func _create_new_node(node_type : String) -> void:
	var mousePos := scripting_graph.get_local_mouse_position()
	var inst : ScriptingNode = node_scene_list[node_type].instance()
	inst.offset = node_searcher.rect_position - scripting_graph.rect_global_position + scripting_graph.scroll_offset
	scripting_graph.add_child(inst)
	node_searcher.hide()
	Globals.emit_signal("scripting_node_added", inst)


func on_SaveBtn_pressed() -> void:
	_target_entity.brain_dict = scripting_graph.save()
	print(_target_entity.brain_dict)
	_target_entity.reset_position()
	close()


func on_RestoreBtn_pressed() -> void:
	load_nodes(_target_entity.brain.brain)


func on_CancelBtn_pressed() -> void:
	close()
