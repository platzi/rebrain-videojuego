tool


extends Entity


onready var animation_player := $AnimationPlayer
onready var open_sfx := $OpenSfx as AudioStreamPlayer2D
onready var close_sfx := $CloseSfx as AudioStreamPlayer2D


var is_open := false


func open() -> void:
	if is_open:
		return
	open_sfx.play()
	animation_player.play("Open")
	is_open = true


func close() -> void:
	if !is_open:
		return
	close_sfx.play()
	animation_player.play("Close")
	is_open = false
