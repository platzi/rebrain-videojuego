extends Control


export(NodePath) var cancel_btn_path
export(NodePath) var save_btn_path


onready var cancel_btn := get_node(cancel_btn_path) as Button
onready var save_btn := get_node(save_btn_path) as Button


func _ready():
	cancel_btn.connect("pressed", self, "_on_CancelBtn_pressed")


func _on_CancelBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
