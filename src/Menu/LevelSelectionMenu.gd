extends Control


export(NodePath) var back_btn_path
export(NodePath) var levels_hbc_path


onready var back_btn := get_node(back_btn_path) as Button
onready var levels_hbc := get_node(levels_hbc_path) as HBoxContainer

onready var button_sfx := $ButtonSfx as AudioStreamPlayer


func _ready():
	BackgroundMusic.play_menu_bgm()
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	_load_levels()


func _load_levels() -> void:
	for child in levels_hbc.get_children():
		if SaveManager.save_data.levels.has(child.name):
			child.completed = true


func _on_BackBtn_pressed() -> void:
	button_sfx.play()
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
