extends Control


var nodes_scenes_list := {}
var is_open := false


onready var node_searcher := $NodeSearcher as PopupPanel
onready var scripting_graph : GraphEdit = $MarginContainer/HBoxContainer/MarginContainer/ScriptingGraph
onready var animation_player : AnimationPlayer = $AnimationPlayer

onready var sprite : Sprite = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Sprite
onready var hair_sprite : Sprite = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/HairSprite
onready var save_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/SaveBtn
onready var restore_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/RestoreBtn
onready var cancel_btn : Button = $MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/CancelBtn
onready var button_sfx := $ButtonSfx as AudioStreamPlayer


var brain := {}

var _target_entity : Entity
var _open_position : Vector2

func _ready() -> void:
	_set_nodes_scenes_list()
	Globals.connect("open_scripting", self, "open")
	Globals.connect("scripting_abort", self, "abort")
	node_searcher.connect("node_selected", self, "_create_new_node")
	scripting_graph.connect("popup_request", self, "open_node_searcher")
	scripting_graph.connect("delete_nodes_request", self, "_on_delete_nodes_request")
	save_btn.connect("pressed", self, "on_SaveBtn_pressed")
	restore_btn.connect("pressed", self, "on_RestoreBtn_pressed")
	cancel_btn.connect("pressed", self, "on_CancelBtn_pressed")
	load_nodes(brain)


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if !Globals.disable_scripting and event.scancode == KEY_TAB:
			if !Globals.scripting_mode:
				BackgroundMusic.activate_eq()
				Globals.scripting_mode = true
				get_tree().paused = true
			else:
				if is_open:
					on_SaveBtn_pressed()
				BackgroundMusic.deactivate_eq()
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
	_set_entity_preview()
	brain = entity.brain.brain
	load_nodes(brain)
	update_nodes_limit()
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
	print(scripting_graph.rect_size)
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


func update_nodes_limit() -> void:
	var _nodes_limit = {}
	for node_type in _target_entity.nodes_limit:
		var node_qty = _target_entity.nodes_limit[node_type]
		if node_qty != 0:
			_nodes_limit[node_type] = node_qty
	node_searcher.nodes_limit = _nodes_limit
	for child in scripting_graph.get_children():
		if child is ScriptingNode and child.visible:
			var node := child as ScriptingNode
			var node_type = node.type
			if node_searcher.nodes_limit.has(node_type) and node_searcher.nodes_limit[node_type] > 0:
				node_searcher.nodes_limit[node_type] -= 1


func load_nodes(nodes) -> void:
	scripting_graph.delete_all_nodes()
	# Instance nodes
	for key in nodes:
		var node = nodes[key]
		if !nodes_scenes_list.has(node.type):
			continue
		var inst : ScriptingNode = nodes_scenes_list[node.type].instance()
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
			var node_to : ScriptingNode = nodes[connection.to].instance
			var node_to_port : ScriptingNodeSlot = node_to.get_slot(connection.to_port)
			node_to_port.hide_left_input()
			scripting_graph.connect_node(from.name, connection.from_port, node_to.name, connection.to_port)


func _set_nodes_scenes_list() -> void:
	for group in NodesList.NODES:
		for node in NodesList.NODES[group]:
			var node_type = node[0]
			var node_scene = node[3]
			nodes_scenes_list[node_type] = node_scene


func _set_entity_preview() -> void:
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


func _create_new_node(node_type : String) -> void:
	var mousePos := scripting_graph.get_local_mouse_position()
	var inst : ScriptingNode = nodes_scenes_list[node_type].instance()
	inst.offset = node_searcher.rect_position - scripting_graph.rect_global_position + scripting_graph.scroll_offset
	scripting_graph.add_child(inst)
	node_searcher.hide()
	Globals.emit_signal("scripting_node_added", inst)
	update_nodes_limit()


func on_SaveBtn_pressed() -> void:
	button_sfx.play()
	_target_entity.brain_dict = scripting_graph.save()
	_target_entity.restart()
	close()


func on_RestoreBtn_pressed() -> void:
	button_sfx.play()
	if _target_entity.brain_og != "":
		var result = JSON.parse(_target_entity.brain_og)
		if result.error == OK:
			load_nodes(result.result)
	else:
		load_nodes({})


func on_CancelBtn_pressed() -> void:
	button_sfx.play()
	close()


func _on_delete_nodes_request(_nodes : Array) -> void:
	get_tree().create_timer(0.1, true).connect("timeout", self, "update_nodes_limit")
