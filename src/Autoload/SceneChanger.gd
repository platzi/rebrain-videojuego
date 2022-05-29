extends CanvasLayer


signal scene_changed

onready var animation_player = $AnimationPlayer
onready var black = $Control/ColorRect


func change_scene(path : String, delay : float = 0.0) -> void:
	Globals.set_last_level(path)
	$Control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	$Control.visible = false


func change_scene_reload(delay : float = 0.0) -> void:
	$Control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().reload_current_scene() == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	$Control.visible = false


func change_scene_to(change_scene : PackedScene) -> void:
	Globals.set_last_level(change_scene.resource_path)
	$Control.visible = true
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene_to(change_scene) == OK)
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	$Control.visible = false