extends Control


signal close_options
onready var back_btn := $BackBtn


func _on_BackBtn_pressed() -> void:
	emit_signal("close_options")
	queue_free()


func _input(event : InputEvent) -> void:
	if event is InputEventKey && event.scancode == KEY_ESCAPE:
		_on_BackBtn_pressed()


func _ready() -> void:
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	back_btn.grab_focus()
