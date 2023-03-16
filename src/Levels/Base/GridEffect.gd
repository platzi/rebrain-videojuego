extends Control


onready var color_rect := $ColorRect
onready var animation_player := $AnimationPlayer


func _ready():
	Globals.connect("scripting_toggled", self, "_on_scripting_toggled")


func _on_scripting_toggled() -> void:
	if Globals.scripting_mode:
		animation_player.play("Shockwave")
	else:
		animation_player.play_backwards("Shockwave")
