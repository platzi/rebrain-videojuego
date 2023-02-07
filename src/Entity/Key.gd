extends Entity


export(NodePath) var cage_path
export(NodePath) var camera_path


onready var tween := $Tween as Tween
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var cage := get_node(cage_path) as Entity
onready var camera := get_node(camera_path) as Node2D


func _ready() -> void:
	animation_player.play("Levitate")
	tween.connect("tween_all_completed", self, "_on_tween_completed")


func _on_Area2D_body_entered_once(body : Node) -> void:
	if !body.is_in_group("Player"):
		return
	tween.interpolate_property(self, "position", position, cage.position, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	camera.target = self
	pause_mode = Node.PAUSE_MODE_PROCESS
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
	cage.unlock()
