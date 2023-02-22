tool


extends Entity


export (PackedScene) var target_scene


export (bool) var is_active := false setget _set_is_active


func _ready():
	pass


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


func _on_Area2D_body_entered_once(body : Node) -> void:
	if body.is_in_group("Player") and is_active:
		body.teleport()
		get_tree().create_timer(0.5).connect("timeout", SceneChanger, "change_scene_to", [target_scene])
