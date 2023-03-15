tool


extends Entity


export (PackedScene) var target_scene


export (bool) var is_active := false setget _set_is_active


onready var area_2d := $Area2D as Area2D
onready var teleport_sfx := $TeleportSfx as AudioStreamPlayer2D


func _ready():
	area_2d.connect("body_entered", self, "_on_body_entered")


func activate() -> void:
	is_active = true
	$AnimationPlayer.play("Open")
	$CPUParticles2D.emitting = true


func deactivate() -> void:
	is_active = false
	$AnimationPlayer.play("RESET")
	$CPUParticles2D.emitting = false


func _set_is_active(new_value : bool) -> void:
	if new_value:
		activate()
	else:
		deactivate()


func _on_body_entered(body : KinematicBody2D) -> void:
	if !is_active:
		return
	if body.is_in_group("Player"):
		teleport_sfx.play()
		body.teleport()
		get_tree().create_timer(0.5).connect("timeout", SceneChanger, "change_scene_to", [target_scene])
