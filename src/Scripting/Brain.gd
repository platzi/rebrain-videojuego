class_name Brain
extends Node2D

signal move_forward
signal move_direction
signal stop_moving
signal turns_towards
signal shoot
signal show_message
signal hide_message
signal explode
signal activate
signal open
signal close

var brain := {}
var isRunning := true


func _ready() -> void:
	if !Engine.editor_hint:
		get_tree().create_timer(0.2).connect("timeout", self, "run")


func run(type = "UPDATE", param1 = null) -> void:
	for node_name in brain:
		var node = brain[node_name]
		if node.type == type:
			if type == "UPDATE" or type == "PRESSED" or type == "RELEASED":
				_execute(node, node)
			elif type == "COLLISION" or type == "TRIGGER":
				node.outputs["1"] = param1
				_execute(node, node)


func stop() -> void:
	isRunning = false


func _execute(start_node, current_node) -> void:
	# Run backwards
	current_node.computed_inputs = current_node.inputs.duplicate()
	if current_node.connections_in.size() > 0:
		for connection in current_node.connections_in:
			if connection.type > 0:
				_run_backwards(brain[connection.from], connection.from_port, current_node, connection.to_port)
	
	match current_node.type:
		"UPDATE":
			yield(get_tree(), "idle_frame")
#			call_deferred("_run_next", start_node, current_node)
			_run_next(start_node, current_node)
		"COLLISION":
			_run_next(start_node, current_node)
		"TRIGGER":
			_run_next(start_node, current_node)
		"PRESSED":
			_run_next(start_node, current_node)
		"RELEASED":
			_run_next(start_node, current_node)
		"MOVE_FORWARD":
			_move_forward(start_node, current_node)
		"MOVE_RIGHT":
			_move_direction(start_node, current_node, "right")
		"MOVE_DOWN":
			_move_direction(start_node, current_node, "down")
		"MOVE_LEFT":
			_move_direction(start_node, current_node, "left")
		"MOVE_UP":
			_move_direction(start_node, current_node, "up")
		"ROTATE_LEFT":
			_rotate_left(start_node, current_node)
		"ROTATE_RIGHT":
			_rotate_right(start_node, current_node)
		"WAIT":
			_wait(start_node, current_node)
		"SHOOT":
			_shoot(start_node, current_node)
		"MESSAGE":
			_message(start_node, current_node)
		"EXPLODE":
			_explode(start_node, current_node)
		"COMPARE_ENTITY":
			_compare_entity(start_node, current_node)
		"SHOOT_TRIGGER":
			_shoot_trigger(start_node, current_node)
		"ACTIVATE":
			_activate(start_node, current_node)
		"OPEN":
			_open(start_node, current_node)
		"CLOSE":
			_close(start_node, current_node)
		"IF":
			_if(start_node, current_node)
		"REPEAT":
			_repeat(start_node, current_node)


func _run_next(start_node : Dictionary, current_node : Dictionary) -> void:
	if !isRunning:
		return
	if Globals.scripting_mode:
		yield(Globals, "scripting_toggled")
	var execute_list := []
	
	# Pass parameters
	if current_node.connections_out.size() > 0:
		for connection in current_node.connections_out:
			if connection.type == 0:
				execute_list.append(brain[connection.to])
	
	# Execute
	if execute_list.size() > 0:
		for exec_node in execute_list:
			_execute(start_node, exec_node)
	elif start_node.type == "UPDATE" or start_node.type == "REPEAT":
		_execute(start_node, start_node)


func _run_backwards(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	current_node.computed_inputs = current_node.inputs.duplicate()
	if current_node.connections_in.size() > 0:
		for connection in current_node.connections_in:
			if connection.type > 0:
				_run_backwards(brain[connection.from], connection.from_port, current_node, connection.to_port)
	
	match current_node.type:
		"TRIGGER":
			_trigger(current_node, port, to_node, to_port)
		"STRING":
			_string(current_node, port, to_node, to_port)
		"NUMBER":
			_number(current_node, port, to_node, to_port)
		"AND":
			_and(current_node, port, to_node, to_port)
		"OR":
			_or(current_node, port, to_node, to_port)
		"EQUAL":
			_equal(current_node, port, to_node, to_port)
		"NOT_EQUAL":
			_not_equal(current_node, port, to_node, to_port)
		"COMPARE_STRING":
			_compare_string(current_node, port, to_node, to_port)
		"GREATER":
			_greater(current_node, port, to_node, to_port)
		"GREATER_EQUAL":
			_greater_equal(current_node, port, to_node, to_port)
		"LESS":
			_less(current_node, port, to_node, to_port)
		"LESS_EQUAL":
			_less_equal(current_node, port, to_node, to_port)
		"PATH_AHEAD":
			_path_ahead(current_node, port, to_node, to_port)
		"PATH_BACK":
			_path_back(current_node, port, to_node, to_port)
		"PATH_RIGHT":
			_path_right(current_node, port, to_node, to_port)
		"PATH_LEFT":
			_path_left(current_node, port, to_node, to_port)
		"PASSENGERS":
			_passengers(current_node, port, to_node, to_port)
		
		"POSITION":
			_position(current_node, port, to_node, to_port)
		"DIRECTION":
			_direction(current_node, port, to_node, to_port)


func _compare_entity(start_node : Dictionary, node : Dictionary) -> void:
	var entity_tags = [
		"Player",
		"Enemy"
	]
	var connections = [{}, {}]
	for connection in node.connections_out:
		if connection.from_port == 0:
			connections[0] = connection
		elif connection.from_port == 1:
			connections[1] = connection
	connections[0].enabled = false
	connections[1].enabled = true
	if node.computed_inputs.has("1") and node.computed_inputs["1"].is_in_group(entity_tags[node.params[0]]):
		connections[0].enabled = true
		connections[1].enabled = false
	_run_next(start_node, node)


func _move_forward(start_node : Dictionary, node : Dictionary) -> void:
	emit_signal("move_forward")
	get_tree().create_timer(1.0, false).connect("timeout", self, "_on_move_forward_end", [start_node, node])


func _on_move_forward_end(start_node : Dictionary, node : Dictionary) -> void:
	emit_signal("stop_moving")
	_run_next(start_node, node)


func _move_direction(start_node : Dictionary, node : Dictionary, direction : String) -> void:
	emit_signal("move_direction", direction)
	get_tree().create_timer(1.0, false).connect("timeout", self, "_on_move_direction_end", [start_node, node])


func _on_move_direction_end(start_node : Dictionary, node : Dictionary) -> void:
	emit_signal("stop_moving")
	_run_next(start_node, node)


func _rotate_left(start_node : Dictionary, node : Dictionary) -> void:
	emit_signal("turns_towards", "left")
	_run_next(start_node, node)


func _rotate_right(start_node : Dictionary, node : Dictionary) -> void:
	emit_signal("turns_towards", "right")
	_run_next(start_node, node)


func _wait(start_node : Dictionary, node : Dictionary) -> void:
	get_tree().create_timer(int(node.computed_inputs["1"]), false).connect("timeout", self, "_run_next", [start_node, node])


func _shoot(start_node : Dictionary, node : Dictionary):
	emit_signal("shoot")
	get_tree().create_timer(1.0, false).connect("timeout", self, "_run_next", [start_node, node])


func _message(start_node : Dictionary, node : Dictionary):
	emit_signal("show_message", node.params[0])
	get_tree().create_timer(node.params[0], false).connect("timeout", self, "_hide_message", [start_node, node], CONNECT_ONESHOT)


func _hide_message(start_node : Dictionary, node):
	emit_signal("hide_message")
	_run_next(start_node, node)


func _explode(start_node : Dictionary, node : Dictionary):
	emit_signal("explode")
	_run_next(start_node, node)


func _shoot_trigger(start_node : Dictionary, node : Dictionary):
	Globals.emit_signal_trigger(node.computed_inputs["1"])
	_run_next(start_node, node)


func _activate(start_node : Dictionary, node : Dictionary):
	emit_signal("activate")
	_run_next(start_node, node)


func _open(start_node : Dictionary, node : Dictionary):
	emit_signal("open")
	_run_next(start_node, node)


func _close(start_node : Dictionary, node : Dictionary):
	emit_signal("close")
	_run_next(start_node, node)


func _if(start_node : Dictionary, node : Dictionary):
	var connections = [{}, {}]
	for connection in node.connections_out:
		if connection.from_port == 0:
			connections[0] = connection
		elif connection.from_port == 1:
			connections[1] = connection
	connections[0].type = -1
	connections[1].type = 0
	if node.computed_inputs["1"] == "true":
		connections[0].type = 0
		connections[1].type = -1
	_run_next(start_node, node)


func _repeat(start_node : Dictionary, node : Dictionary) -> void:
	if node.has("count"):
		node.count -= 1
	else:
		node.count = max(0, int(node.computed_inputs["1"]))
		node.first_node = start_node
	var connections = [{}, {}]
	for connection in node.connections_out:
		if connection.from_port == 0:
			connections[0] = connection
		elif connection.from_port == 1:
			connections[1] = connection
	connections[0].type = -1
	connections[1].type = 0
	if node.count <= 0:
		var first_node = node.first_node
		node.erase("count")
		node.erase("first_node")
		connections[0].type = 0
		connections[1].type = -1
		_run_next(first_node, node)
	else:
		_run_next(node, node)


# CALCULATIONS


func _trigger(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = current_node.outputs["1"]


func _string(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = current_node.outputs["0"]


func _number(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = current_node.outputs["0"]


func _and(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if current_node.computed_inputs["0"] == "true" and current_node.computed_inputs["1"] == "true":
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _or(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if current_node.computed_inputs["0"] == "true" or current_node.computed_inputs["1"] == "true":
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _compare_string(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if current_node.computed_inputs["0"] == current_node.computed_inputs["1"]:
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _equal(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) == int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _not_equal(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) != int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _greater(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) > int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _greater_equal(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) >= int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _less(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) < int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _less_equal(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if int(current_node.computed_inputs["0"]) <= int(current_node.computed_inputs["1"]):
		to_node.computed_inputs[str(to_port)] = "true"
	else:
		to_node.computed_inputs[str(to_port)] = "false"


func _path_ahead(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = "true" if get_parent().get_path_ahead() else "false"


func _path_back(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = "true" if get_parent().get_path_back() else "false"


func _path_left(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = "true" if get_parent().get_path_left() else "false"


func _path_right(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = "true" if get_parent().get_path_right() else "false"


func _passengers(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = str(get_parent().get_passengers())


func _position(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	if port == 0:
		to_node.computed_inputs[str(to_port)] = str(int(get_parent().position.x))
	elif port == 1:
		to_node.computed_inputs[str(to_port)] = str(int(get_parent().position.y))


func _direction(current_node : Dictionary, port : int, to_node : Dictionary, to_port : int) -> void:
	to_node.computed_inputs[str(to_port)] = str(int(get_parent().direction))
