extends Node2D


export(NodePath) var target_path setget _set_target_path
var target : Node2D

var attractor : Area2D

onready var camera_2d : Camera2D = $Camera2D
onready var area_2d : Area2D = $Area2D
onready var screenshake_timer : Timer = $ScreenshakeTimer

var _screenshake_ammount := 0.0
var _screenshake_is_active := false
var _is_ready := false

func _ready() -> void:
	_is_ready = true
	
	area_2d.connect("area_entered", self, "_on_Area2D_area_entered")
	area_2d.connect("area_exited", self, "_on_Area2D_area_exited")
	screenshake_timer.connect("timeout", self, "_on_ScreenshakeTimer_timeout")
	Globals.connect("screenshake", self, "screenshake")
	
	_set_target_path(target_path)


func _process(delta : float) -> void:
	if is_instance_valid(target):
		position = target.position
	if attractor:
		camera_2d.global_position = attractor.position
	if _screenshake_is_active:
		camera_2d.offset = Vector2(rand_range(-1.0, 1.0) * _screenshake_ammount, rand_range(-1.0, 1.0) * _screenshake_ammount)


func screenshake(time : float, ammount : float) -> void:
	_screenshake_ammount = ammount
	screenshake_timer.start(time)
	_screenshake_is_active = true


func _set_target_path(new_value : NodePath) -> void:
	target_path = new_value
	if !_is_ready:
		return
	target = get_node(target_path)


func _on_Area2D_area_entered(area : Area2D) -> void:
	attractor = area


func _on_Area2D_area_exited(area : Area2D) -> void:
	attractor = null
	camera_2d.position = Vector2.ZERO


func _on_ScreenshakeTimer_timeout() -> void:
	_screenshake_is_active = false
	camera_2d.offset = Vector2.ZERO
	Globals.emit_signal("screenshake_finished")
