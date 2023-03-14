extends Node2D

const ZOOM_SPEED := 5

export(NodePath) var target_path setget _set_target_path
var target : Node2D

var attractor : Area2D

onready var camera_2d : Camera2D = $Camera2D
onready var area_2d : Area2D = $Area2D
onready var screenshake_timer : Timer = $ScreenshakeTimer

var _zoom_smooth := 1.0
var _zoom_target := 1.0
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
	camera_2d.smoothing_enabled = false
	yield(get_tree(), "idle_frame")
	if target:
		position = target.position
	if attractor:
		_zoom_smooth = attractor.zoom_level
		_zoom_target = attractor.zoom_level
		camera_2d.zoom = Vector2(_zoom_smooth, _zoom_smooth)
		camera_2d.global_position = attractor.global_position
	yield(get_tree(), "idle_frame")
	camera_2d.smoothing_enabled = true


func _process(delta : float) -> void:
	_zoom_smooth = lerp(_zoom_smooth, _zoom_target, ZOOM_SPEED * delta)
	camera_2d.zoom = Vector2(_zoom_smooth, _zoom_smooth)
	if get_tree().paused:
		var space = get_world_2d().direct_space_state
		var cols = space.intersect_point(global_position, 32, [area_2d], 32768, false, true)
		var remove := true
		for col in cols:
			if col.collider.is_in_group("CameraAttractor"):
				remove = false
				break
		if remove:
			attractor = null
			camera_2d.position = Vector2.ZERO
	if is_instance_valid(target):
		position = target.position
	if attractor:
		camera_2d.global_position = attractor.global_position
		_zoom_target = attractor.zoom_level
	else:
		_zoom_target = 1.0
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
	if area.is_in_group("CameraAttractor"):
		attractor = area


func _on_Area2D_area_exited(_area : Area2D) -> void:
	if _area == attractor:
		attractor = null
		camera_2d.position = Vector2.ZERO


func _on_ScreenshakeTimer_timeout() -> void:
	_screenshake_is_active = false
	camera_2d.offset = Vector2.ZERO
	Globals.emit_signal("screenshake_finished")
