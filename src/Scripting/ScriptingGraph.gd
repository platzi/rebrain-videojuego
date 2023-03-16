extends GraphEdit

func _ready():
	# Connections
	connect("connection_request", self, "_on_connection_request")
	connect("disconnection_request", self, "_on_disconnection_request")
	connect("delete_nodes_request", self, "_on_delete_nodes_request")
	connect("node_selected", self, "_on_node_selected")
	# Hide zoom hbox
	get_zoom_hbox().visible = false


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Globals.DEBUG:
			if event.scancode == KEY_P:
				var save_string = JSON.print(save())
				OS.clipboard = save_string
				print(save_string)
			elif event.scancode == KEY_F3:
				_disable_selected()


func save() -> Dictionary:
	var nodes = {}
	for child in get_children():
		if child is GraphNode:
			nodes[child.name] = {
				type = child.type,
				disabled = child.disabled,
				position = [child.offset.x, child.offset.y],
				connections_in = [],
				connections_out = [],
				computed_inputs = child.get_inputs(),
				inputs = child.get_inputs(),
				outputs = child.get_outputs()
			}
	for connection in get_connection_list():
		var node_to_instance : GraphNode = get_node(connection.to)
		var node_from_instance : GraphNode = get_node(connection.from)
		nodes[connection.from].connections_out.append({
			type = node_from_instance.get_connection_output_type(connection.from_port),
			from_port = connection.from_port,
			to = connection.to,
			to_port = connection.to_port
		})
		nodes[connection.to].connections_in.append({
			type = node_to_instance.get_connection_input_type(connection.to_port),
			from = connection.from,
			from_port = connection.from_port,
			to_port = connection.to_port
		})
	return nodes


func delete_all_nodes() -> void:
	var disconnect_list := []
	for child in get_children():
		if child is GraphNode:
			disconnect_list.append(child.name)
			child.visible = false
			child.queue_free()
	for connection in get_connection_list():
		if disconnect_list.has(connection.to) or disconnect_list.has(connection.from):
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)


func _delete_selected() -> void:
	var disconnect_list := []
	for child in get_children():
		if child is GraphNode && child.selected:
			disconnect_list.append(child.name)
			child.queue_free()
	for connection in get_connection_list():
		if disconnect_list.has(connection.to) or disconnect_list.has(connection.from):
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)


func _disable_selected() -> void:
	for child in get_children():
		if child is GraphNode && child.selected:
			child.disabled = !child.disabled


func _on_connection_request(from : String, from_slot : int, to : String, to_slot : int) -> void:
	var connections = get_connection_list()
	var node_to : ScriptingNode = get_node(to)
	for connection in connections:
		var conn_node_from : ScriptingNode = get_node(connection.from)
		var conn_node_to : ScriptingNode = get_node(connection.to)
		if connection.from == from and connection.from_port == from_slot and conn_node_from.get_connection_output_type(from_slot) <= 0:
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
		elif connection.to == to && connection.to_port == to_slot:
			var conn_node_slot : ScriptingNodeSlot = conn_node_to.get_slot(connection.to_port)
			conn_node_slot.show_left_input()
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	var node_slot : ScriptingNodeSlot = node_to.get_slot(to_slot)
	node_slot.hide_left_input()
	connect_node(from, from_slot, to, to_slot)
	Globals.emit_signal("scripting_node_connection", get_node(from), from_slot, get_node(to), to_slot)


func _on_disconnection_request(from : String, from_slot : int, to : String, to_slot : int) -> void:
	var node_to : ScriptingNode = get_node(to)
	var node_slot : ScriptingNodeSlot = node_to.get_slot(to_slot)
	node_slot.show_left_input()
	disconnect_node(from, from_slot, to, to_slot)


func _on_node_selected(_node : Node) -> void:
	pass


func _on_delete_nodes_request(_nodes : Array) -> void:
	for node_name in _nodes:
		for connection in get_connection_list():
			if connection.from == node_name or connection.to == node_name:
				_on_disconnection_request(connection.from, connection.from_port, connection.to, connection.to_port)
		if has_node(node_name):
			get_node(node_name).queue_free()
