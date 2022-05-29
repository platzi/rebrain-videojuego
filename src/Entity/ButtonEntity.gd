extends Entity

func _ready():
	speed = 60
	
	
func _on_Area2D_body_exited(body) -> void:
	$AnimationPlayer.play("RESET")
