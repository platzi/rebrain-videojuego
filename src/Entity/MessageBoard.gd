extends Control

onready var animation_player = $AnimationPlayer


func show_message():
	animation_player.play("PopUp")


func hide_message():
	animation_player.play("PopDown")

