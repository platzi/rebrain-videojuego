extends Entity

export (PackedScene) var target_scene


var is_active := false


func _ready():
	print(target_scene)
	$AnimationPlayer.play("RESET")


func activate() -> void:
	is_active = true
	$AnimationPlayer.play("Open")
	$CPUParticles2D.emitting = true


func deactivate() -> void:
	is_active = false
	$AnimationPlayer.play("ButtonPressed")
	$CPUParticles2D.emitting = false


func _on_Area2D_body_entered_once(body : Node) -> void:
	if body.is_in_group("Player") and is_active:
		body.teleport()
		get_tree().create_timer(0.5).connect("timeout", SceneChanger, "change_scene_to", [target_scene])
