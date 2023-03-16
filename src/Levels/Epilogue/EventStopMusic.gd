extends EventCustom


func execute() -> void:
	BackgroundMusic.stream_paused = true
	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("finished")
