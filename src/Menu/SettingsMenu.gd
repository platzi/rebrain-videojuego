extends Control


export(NodePath) var music_value_label_path
export(NodePath) var music_hs_path
export(NodePath) var sfx_value_label_path
export(NodePath) var sfx_hs_path
export(NodePath) var cancel_btn_path
export(NodePath) var save_btn_path


onready var music_value_label := get_node(music_value_label_path) as Label
onready var music_hs := get_node(music_hs_path) as HSlider
onready var sfx_value_label := get_node(sfx_value_label_path) as Label
onready var sfx_hs := get_node(sfx_hs_path) as HSlider
onready var cancel_btn := get_node(cancel_btn_path) as Button
onready var save_btn := get_node(save_btn_path) as Button


func _ready():
	music_hs.connect("value_changed", self, "_on_MusicHS_value_changed")
	sfx_hs.connect("value_changed", self, "_on_SfxHS_value_changed")
	cancel_btn.connect("pressed", self, "_on_CancelBtn_pressed")


func _on_MusicHS_value_changed(value : float) -> void:
	music_value_label.text = str(value) + "%"


func _on_SfxHS_value_changed(value : float) -> void:
	sfx_value_label.text = str(value) + "%"


func _on_CancelBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
