extends Control


signal close_credits


func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		emit_signal("close_credits")
		queue_free()

