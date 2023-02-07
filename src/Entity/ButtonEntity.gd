extends Entity


onready var animation_player := $AnimationPlayer


var pressed := false


func _on_Area2D_body_exited(_body) -> void:
	if !pressed:
		return
	pressed = false
	animation_player.play("RESET")
	brain.run("RELEASED")


func _on_Area2D_body_entered(body : Node) -> void:
	if pressed or !body.is_in_group("Player") and !body.is_in_group("Enemy") and !body.is_in_group("Friend"):
		return
	pressed = true
	animation_player.play("Pressed")
	brain.run("PRESSED")
