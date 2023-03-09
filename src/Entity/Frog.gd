tool


extends Entity


onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	if Engine.editor_hint:
		set_process(false)
		_process(0.0)


func _process(_delta : float) -> void:
	if direction == 0.0 || direction == 360.0:
		animation_player.current_animation = "Right"
	elif direction == 90.0:
		animation_player.current_animation = "Down"
	elif direction == 180.0:
		animation_player.current_animation = "Left"
	elif direction == 270.0:
		animation_player.current_animation = "Up"
	if speed != 0.0:
		animation_player.playback_speed = 1.0
	else:
		animation_player.playback_speed = 0.0
		animation_player.seek(0.0)
