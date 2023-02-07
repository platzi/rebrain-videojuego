extends Control

var node_scene_list := {
	UPDATE = preload("res://src/Scripting/Nodes/UpdateNode.tscn"),
	COLLISION = preload("res://src/Scripting/Nodes/CollisionNode.tscn"),
	TRIGGER = preload("res://src/Scripting/Nodes/TriggerNode.tscn"),
	PRESSED = preload("res://src/Scripting/Nodes/PressedNode.tscn"),
	RELEASED = preload("res://src/Scripting/Nodes/ReleasedNode.tscn"),
	MOVE_FORWARD = preload("res://src/Scripting/Nodes/MoveForwardNode.tscn"),
	ROTATE = preload("res://src/Scripting/Nodes/RotateNode.tscn"),
	TIMER = preload("res://src/Scripting/Nodes/TimerNode.tscn"),
	SHOOT = preload("res://src/Scripting/Nodes/ShootNode.tscn"),
	EXPLODE = preload("res://src/Scripting/Nodes/ExplodeNode.tscn"),
	MESSAGE = preload("res://src/Scripting/Nodes/MessageNode.tscn"),
	COMPARE_ENTITY = preload("res://src/Scripting/Nodes/CompareEntityNode.tscn"),
	COMPARE_STRING = preload("res://src/Scripting/Nodes/CompareStringNode.tscn"),
	SHOOT_TRIGGER = preload("res://src/Scripting/Nodes/ShootTriggerNode.tscn"),
	ACTIVATE = preload("res://src/Scripting/Nodes/ActivateNode.tscn"),
	OPEN = preload("res://src/Scripting/Nodes/OpenNode.tscn"),
	CLOSE = preload("res://src/Scripting/Nodes/CloseNode.tscn")
}

var is_open := false

onready var scripting_effect : Control = $ScriptingEffect

onready var node_searcher := $NodeSearcher
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
			Globals.emit_signal("scripting_toggled")
			if !Globals.scripting_mode:
				Globals.scripting_mode = true
				get_tree().paused = true
				scripting_effect.visible = true
			elif is_open:
					on_SaveBtn_pressed()
			else:
				Globals.scripting_mode = false
				get_tree().paused = false
				scripting_effect.visible = false
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
		var inst : ScriptingNode = node_scene_list[node.type].instance()
		inst.offset.x = node.position[0]
		inst.offset.y = node.position[1]
		inst.disabled = node.disabled
		inst.set_params(node.params)
		scripting_graph.add_child(inst)
		nodes[key].instance = inst
	node_searcher.hide()
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
