extends GraphEdit

func _ready():
	# Connections
	connect("connection_request", self, "_on_connection_request")
	connect("disconnection_request", self, "_on_disconnection_request")
	connect("delete_nodes_request", self, "_on_delete_nodes_request")
	connect("node_selected", self, "_on_node_selected")
	# Hide zoom hbox
	get_zoom_hbox().visible = false


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_DELETE:
			_delete_selected()
		if Globals.DEBUG:
			if event.scancode == KEY_F2:
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
				connections = [],
				params = child.get_params(),
				inputs = {}
			}
	for connection in get_connection_list():
		var node_instance : GraphNode = get_node(connection.from)
		nodes[connection.from].connections.append({
			type = node_instance.get_connection_output_type(connection.from_port),
			from_port = connection.from_port,
			to = connection.to,
			to_port = connection.to_port,
			output = 1,
			enabled = true
		})
	return nodes


func delete_all_nodes() -> void:
	var disconnect_list := []
	for child in get_children():
		if child is GraphNode:
			disconnect_list.append(child.name)
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
	for connection in connections:
		if connection.from == from && connection.from_port == from_slot:
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
		elif connection.to == to && connection.to_port == to_slot:
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	Globals.emit_signal("scripting_node_connection", get_node(from), from_slot, get_node(to), to_slot)
	connect_node(from, from_slot, to, to_slot)


func _on_disconnection_request(from : String, from_slot : int, to : String, to_slot : int) -> void:
	disconnect_node(from, from_slot, to, to_slot)


func _on_node_selected(_node : Node) -> void:
	pass


func _on_delete_nodes_request() -> void:
	pass
