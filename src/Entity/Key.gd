tool


extends Entity


export(NodePath) var cage_path
export(NodePath) var camera_path


onready var area_2d := $Area2D as Area2D
onready var tween := $Tween as Tween
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var cage := get_node_or_null(cage_path) as Entity
onready var camera := get_node_or_null(camera_path) as Node2D


onready var pick_up_sfx := $PickUpSfx as AudioStreamPlayer2D
onready var travel_sfx := $TravelSfx as AudioStreamPlayer2D
onready var punch_sfx := $PunchSfx as AudioStreamPlayer2D


func _ready() -> void:
	animation_player.play("Levitate")
	tween.connect("tween_all_completed", self, "_on_tween_completed")
	area_2d.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body : KinematicBody2D) -> void:
	if !body.is_in_group("Player") and !body.is_in_group("Friend"):
		return
	pick_up_sfx.play()
	tween.interpolate_property(self, "position", position, cage.position, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_tree().create_timer(0.2).connect("timeout", travel_sfx, "play")
	tween.start()
	pause_mode = Node.PAUSE_MODE_PROCESS
	camera.target = self
	z_as_relative = false
	z_index = 10
	Globals.disable_inputs = true
	Globals.disable_scripting = true
	get_tree().paused = true


func _on_tween_completed() -> void:
	animation_player.play("Disappear")
	cage.pause_mode = PAUSE_MODE_PROCESS


func _unlock_cage() -> void:
	if !cage:
		return
	punch_sfx.play()
	cage.unlock()
