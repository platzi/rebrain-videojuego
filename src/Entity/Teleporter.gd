extends Entity

export (PackedScene) var target_scene


func _ready():
	$AnimationPlayer.play("RESET")
	.set_change_scene(target_scene)
