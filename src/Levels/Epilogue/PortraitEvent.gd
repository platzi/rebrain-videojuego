extends EventCustom


export(NodePath) var portrait_animation_player_path
onready var animation_player := get_node(portrait_animation_player_path) as AnimationPlayer


func execute() -> void:
	animation_player.play("Enter")
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("finished")
