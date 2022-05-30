extends Control

export(NodePath) var return_btn_path 


signal close_credits


onready var return_btn : Button = get_node(return_btn_path)


func _ready() -> void:
	return_btn.connect("pressed", self, "_on_ReturnBtn_pressed")
	$AnimationPlayer.play("Show")


func _on_ReturnBtn_pressed() -> void:
	$AnimationPlayer.play("Hide")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	emit_signal("close_credits")
