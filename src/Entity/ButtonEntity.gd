extends Entity


onready var animation_player := $AnimationPlayer


func _on_Area2D_body_exited(body) -> void:
	animation_player.play("RESET")


func _on_Area2D_body_entered(body : Node) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy") or body.is_in_group("Friend"):
		animation_player.play("Pressed")
