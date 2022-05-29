extends Node2D


export(NodePath) var target_path setget _set_target_path
var target : Node2D

var attractor : Area2D

onready var camera_2d : Camera2D = $Camera2D
onready var area_2d : Area2D = $Area2D

var _is_ready = false

func _ready() -> void:
	_is_ready = true
	
	area_2d.connect("area_entered", self, "_on_Area2D_area_entered")
	area_2d.connect("area_exited", self, "_on_Area2D_area_exited")
	
	_set_target_path(target_path)


func _process(delta : float) -> void:
	if is_instance_valid(target):
		position = target.position
	if attractor:
		camera_2d.global_position = attractor.position


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
