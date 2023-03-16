extends AudioStreamPlayer2D


func _ready() -> void:
	get_tree().create_timer(1.0).connect("timeout", self, "queue_free")
