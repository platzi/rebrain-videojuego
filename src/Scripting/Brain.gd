class_name Brain
extends Node2D

signal move_forward
signal stop_moving
signal turns_towards
signal shoot
signal show_message
signal hide_message
signal explode
signal activate

var brain := {}
var isRunning := true

func _ready() -> void:
	run()


func run(type = "UPDATE", param1 = null) -> void:
	for node_name in brain:
		var node = brain[node_name]
		if node.type == type:
			if type == "UPDATE":
				_execute(node, node)
			elif type == "COLLISION" or type == "TRIGGER":
				for connection in node.connections:
					if connection.from_port == 1:
						connection.output = param1
				_execute(node, node)


func stop() -> void:
	print("stop")
	isRunning = false


func _execute(start_node, current_node) -> void:
	match current_node.type:
		"UPDATE":
			_run_next(start_node, current_node)
		"COLLISION":
			_run_next(start_node, current_node)
		"TRIGGER":
			_run_next(start_node, current_node)
		"MOVE_FORWARD":
			_move_forward(start_node, current_node)
		"ROTATE":
			_rotate(start_node, current_node)
		"TIMER":
			_timer(start_node, current_node)
		"SHOOT":
			_shoot(start_node, current_node)
		"MESSAGE":
			_message(start_node, current_node)
		"EXPLODE":
			_explode(start_node, current_node)
		"COMPARE_ENTITY":
			_compare_entity(start_node, current_node)
		"COMPARE_STRING":
			_compare_string(start_node, current_node)
		"SHOOT_TRIGGER":
			_shoot_trigger(start_node, current_node)
		"ACTIVATE":
			_activate(start_node, current_node)


func _run_next(start_node, current_node) -> void:
	if !isRunning:
		return
	if Globals.scripting_mode:
		yield(Globals, "scripting_toggled")
	yield(get_tree(), "idle_frame")
	var execute_list := []
	
	# Pass parameters
	var next_node = current_node
	if current_node.connections.size() > 0:
		for connection in current_node.connections:
			if connection.type == 0 and connection.enabled:
				execute_list.append(brain[connection.to])
			else:
				print(connection.to_port)
				brain[connection.to].inputs[str(connection.to_port)] = connection.output
	
	# Execute
	if execute_list.size() > 0:
		for exec_node in execute_list:
			_execute(start_node, exec_node)
	elif start_node.type == "UPDATE":
		_execute(start_node, start_node)


func _compare_entity(start_node : Dictionary, node : Dictionary) -> void:
	print("compare_entity")
	var entity_tags = [
		"Player",
		"Enemy"
	]
	var connections = [{}, {}]
	for connection in node.connections:
		if connection.from_port == 0:
			connections[0] = connection
		elif connection.from_port == 1:
			connections[1] = connection
	connections[0].enabled = false
	connections[1].enabled = true
	if node.inputs.has("1") and node.inputs["1"].is_in_group(entity_tags[node.params[0]]):
		connections[0].enabled = true
		connections[1].enabled = false
	_run_next(start_node, node)


func _compare_string(start_node : Dictionary, node : Dictionary) -> void:
	print("compare_string")
	var connections = [{}, {}]
	for connection in node.connections:
		if connection.from_port == 0:
			connections[0] = connection
		elif connection.from_port == 1:
			connections[1] = connection
	connections[0].enabled = false
	connections[1].enabled = true
	if node.inputs["1"] == node.params[0]:
		connections[0].enabled = true
		connections[1].enabled = false
	_run_next(start_node, node)

func _move_forward(start_node : Dictionary, node : Dictionary) -> void:
	print("move_forward")
	emit_signal("move_forward")
	get_tree().create_timer(node.params[0], false).connect("timeout", self, "_on_move_forward_end", [start_node, node])
#	_timer.connect("timeout", self, "_on_move_forward_end", [start_node, node], CONNECT_ONESHOT)
#	_timer.start(node.params[0])


func _on_move_forward_end(start_node : Dictionary, node : Dictionary) -> void:
	print("stop_moving")
	emit_signal("stop_moving")
	_run_next(start_node, node)


func _rotate(start_node : Dictionary, node : Dictionary) -> void:
	print("turns_towards")
	emit_signal("turns_towards", "left" if node.params[0] == 0 else "right")
	_run_next(start_node, node)


func _timer(start_node : Dictionary, node : Dictionary) -> void:
	print("timer_start")
	get_tree().create_timer(node.params[0], false).connect("timeout", self, "_run_next", [start_node, node])


func _shoot(start_node : Dictionary, node : Dictionary):
	print("shoot")
	emit_signal("shoot")
	_run_next(start_node, node)


func _message(start_node : Dictionary, node : Dictionary):
	print("show_message")
	emit_signal("show_message", node.params[0])
	get_tree().create_timer(node.params[0], false).connect("timeout", self, "_hide_message", [start_node, node], CONNECT_ONESHOT)


func _hide_message(start_node : Dictionary, node):
	print("hide_message")
	emit_signal("hide_message")
	_run_next(start_node, node)


func _explode(start_node : Dictionary, node : Dictionary):
	print("explode")
	emit_signal("explode")
	_run_next(start_node, node)


func _shoot_trigger(start_node : Dictionary, node : Dictionary):
	print("shoot_trigger")
	Globals.emit_signal_trigger(node.params[0])
	_run_next(start_node, node)


func _activate(start_node : Dictionary, node : Dictionary):
	print("activate")
	emit_signal("activate")
	_run_next(start_node, node)
