extends Control

onready var animation_player = $AnimationPlayer
onready var message_label = $MarginContainer2/MarginContainer/MessageLabel


func show_message() -> void:
	animation_player.play("PopUp")


func hide_message() -> void:
	animation_player.play("PopDown")


func set_text(message : String) -> void:
	message_label.text = message
