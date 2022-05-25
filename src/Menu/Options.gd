extends Control

signal close_options

onready var backBtn := $BackBtn

func _on_BackBtn_pressed():
	emit_signal("close_options")
	queue_free()

func _input(event):
	if event is InputEventKey && event.scancode == KEY_ESCAPE:
		_on_BackBtn_pressed()

func _ready():
	backBtn.connect("pressed", self, "_on_BackBtn_pressed")
	backBtn.grab_focus()
