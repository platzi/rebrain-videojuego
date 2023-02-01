extends Control


export(NodePath) var back_btn_path


onready var back_btn := get_node(back_btn_path) as Button


func _ready():
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")


func _on_BackBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
