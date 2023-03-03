extends Entity


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var visibility_notifier := $VisibilityNotifier2D as VisibilityNotifier2D


func _ready():
	animation_player.play("Spin")
	visibility_notifier.connect("screen_exited", self, "_on_screen_exited")


func _on_screen_exited() -> void:
	queue_free()


func _on_hit() -> void:
	destroy()
