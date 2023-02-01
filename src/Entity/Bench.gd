tool


extends Entity


export(String, "IdleRight", "IdleUp", "IdleLeft", "IdleDown") var animation = "IdleDown" setget _set_animation


onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_set_animation(animation)


func _set_animation(new_value : String) -> void:
	animation = new_value
	if !animation_player:
		return
	animation_player.play(animation)
