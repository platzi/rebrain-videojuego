extends Entity

export (bool) var is_active setget _set_is_active
export (PackedScene) var target_scene


func _ready():
	$AnimationPlayer.play("RESET")
	.set_change_scene(target_scene)
	_set_is_active(is_active)


func activate() -> void:
	is_open = true
	$AnimationPlayer.play("Open")
	$CPUParticles2D.emitting = true
	$AudioStreamPlayer2D.play()


func deactivate() -> void:
	is_open = false
	$AnimationPlayer.play("ButtonPressed")
	$CPUParticles2D.emitting = false
	$AudioStreamPlayer2D.play()
	

func _set_is_active(new_value : bool) -> void:
	is_active = new_value
	if is_active:
		activate()
	else:
		deactivate()
