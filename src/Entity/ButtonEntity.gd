tool


extends Entity


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var area_2d := $Area2D as Area2D


var pressed := false


func _ready() -> void:
	area_2d.connect("body_entered", self, "_on_body_entered")
	area_2d.connect("body_exited", self, "_on_body_exited")


func _on_body_exited(_body) -> void:
	if !pressed:
		return
	pressed = false
	animation_player.play("RESET")
	brain.run("RELEASED")


func _on_body_entered(body : Node) -> void:
	if pressed or !body.is_in_group("Player") and !body.is_in_group("Enemy") and !body.is_in_group("Friend"):
		return
	pressed = true
	animation_player.play("Pressed")
	brain.run("PRESSED")
