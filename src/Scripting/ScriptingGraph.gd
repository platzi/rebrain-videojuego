extends GraphEdit

func _ready():
	# Connections
	connect("connection_request", self, "_on_connection_request")
	connect("disconnection_request", self, "_on_disconnection_request")
	
	# Hide zoom hbox
	get_zoom_hbox().visible = false


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_A and event.pressed:
		run()


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


func run() -> void:
	yield(get_tree(), "idle_frame")
	var connections = get_connection_list()
	for connection in connections:
		var from_node = get_node(connection.from)
		if from_node.type == "UPDATE":
			from_node.connect("run_finished", self, "_run_next", [connection.to], CONNECT_ONESHOT)
			from_node.run()
			return


func _run_next(from : String) -> void:
	var to = ""
	var connections = get_connection_list()
	var from_node = get_node(from)
	for connection in connections:
		if connection.from == from:
			from_node.connect("run_finished", self, "_run_next", [connection.to], CONNECT_ONESHOT)
			from_node.run()
			return
	from_node.connect("run_finished", self, "run", [], CONNECT_ONESHOT)
	from_node.run()
