class_name Brain
extends Node2D

signal move_forward
signal stop_moving
signal turns_towards
signal shoot
signal show_message
signal hide_message

var brain := {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}
var _start_node
var _next_node
var _timer


func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	run()


func run() -> void:
	for node_name in brain:
		var node = brain[node_name]
		if node.type == "UPDATE":
			_start_node = node
			_next_node = node
			_run_next()


func _run_next() -> void:
	yield(get_tree(), "idle_frame")
	
	# Find next node or return to the start
	var current_node = _next_node
	if current_node.connections.size() > 0:
		_next_node = brain[current_node.connections[0].to]
	else:
		_next_node = _start_node
		
	# Run commands
	match current_node.type:
		"UPDATE":
			_run_next()
		"MOVE_FORWARD":
			_move_forward(current_node)
		"ROTATE":
			_rotate(current_node)
		"TIMER":
			_timer(current_node)
		"SHOOT":
			_shoot(current_node)
		"MESSAGE":
			_message(current_node)


func _move_forward(node : Dictionary) -> void:
	print("move_forward")
	emit_signal("move_forward")
	_timer.connect("timeout", self, "_on_move_forward_end", [], CONNECT_ONESHOT)
	_timer.start(node.params[0])


func _on_move_forward_end() -> void:
	print("stop_moving")
	emit_signal("stop_moving")
	_run_next()


func _rotate(node : Dictionary) -> void:
	print("turns_towards")
	emit_signal("turns_towards", "left" if node.params[0] == 0 else "right")
	_run_next()


func _timer(node : Dictionary) -> void:
	print("timer_start")
	_timer.connect("timeout", self, "_run_next", [], CONNECT_ONESHOT)
	_timer.start(node.params[0])


func _shoot(node : Dictionary):
	print("shoot")
	emit_signal("shoot")
	_run_next()


func _message(node : Dictionary):
	print("show_message")
	emit_signal("show_message", node.params[0])
	_timer.connect("timeout", self, "_hide_message", [], CONNECT_ONESHOT)
	_timer.start(node.params[1])


func _hide_message():
	print("hide_message")
	emit_signal("hide_message")
	_run_next()
