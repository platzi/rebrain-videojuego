extends CanvasLayer


signal scene_changed

onready var animation_player := $AnimationPlayer
onready var control := $Control
onready var black := $Control/ColorRect


func change_scene(path : String) -> void:
	control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	control.visible = false


func change_scene_reload() -> void:
	control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().reload_current_scene() == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	control.visible = false


func change_scene_to(change_scene : PackedScene) -> void:
	control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene_to(change_scene) == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	control.visible = false
