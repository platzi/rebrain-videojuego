extends Entity

export (bool) var is_active setget _set_is_active
export (PackedScene) var target_scene


func _ready():
	print(target_scene)
	$AnimationPlayer.play("RESET")
	_set_is_active(is_active)


func activate() -> void:
	is_open = true
	$AnimationPlayer.play("Open")
	$CPUParticles2D.emitting = true


func deactivate() -> void:
	is_open = false
	$AnimationPlayer.play("ButtonPressed")
	$CPUParticles2D.emitting = false


func _set_is_active(new_value : bool) -> void:
	is_active = new_value
	if is_active:
		activate()
	else:
		deactivate()


func _on_Area2D_body_entered_once(body : Node) -> void:
	if body.is_in_group("Player") and is_open:
		body.teleport()
		get_tree().create_timer(0.5).connect("timeout", SceneChanger, "change_scene_to", [target_scene])
