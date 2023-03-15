extends EventCustom


export(NodePath) var freddy_path


onready var freddy := get_node(freddy_path) as Entity


func execute() -> void:
	freddy.reveal()
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("finished")
