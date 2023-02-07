extends Entity


onready var animation_player := $AnimationPlayer


var is_open := false


func open() -> void:
	if is_open:
		return
	animation_player.play("Open")
	is_open = true


func close() -> void:
	if !is_open:
		return
	animation_player.play("Close")
	is_open = false
