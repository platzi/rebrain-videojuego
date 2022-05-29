extends GraphEdit

func _ready():
	# Connections
	connect("connection_request", self, "_on_connection_request")
	connect("disconnection_request", self, "_on_disconnection_request")
	connect("delete_nodes_request", self, "_on_delete_nodes_request")
	# Hide zoom hbox
	get_zoom_hbox().visible = false


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_DELETE:
			_delete_selected()
		elif event.scancode == KEY_G:
			save()


func save() -> Dictionary:
	var nodes = {}
	for child in get_children():
		if child is GraphNode:
			nodes[child.name] = {
				type = child.type,
				position = [child.offset.x, child.offset.y],
				connections = [],
				params = child.get_params()
			}
	for connection in get_connection_list():
		nodes[connection.from].connections.append({
			from_port = connection.from_port,
			to = connection.to,
			to_port = connection.to_port
		})
	return nodes


func _delete_selected() -> void:
	var disconnect_list := []
	for child in get_children():
		if child is GraphNode && child.selected:
			disconnect_list.append(child.name)
			child.queue_free()
	for connection in get_connection_list():
		if disconnect_list.has(connection.to) or disconnect_list.has(connection.from):
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)


func _on_connection_request(from : String, from_slot : int, to : String, to_slot : int) -> void:
	var connections = get_connection_list()
	for connection in connections:
		if connection.from == from && connection.from_port == from_slot:
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
		elif connection.to == to && connection.to_port == to_slot:
			disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	connect_node(from, from_slot, to, to_slot)


func _on_disconnection_request(from : String, from_slot : int, to : String, to_slot : int) -> void:
	disconnect_node(from, from_slot, to, to_slot)


func _on_delete_nodes_request() -> void:
	pass
