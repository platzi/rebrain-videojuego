extends Control

export(NodePath) var start_btn_path 
export(NodePath) var menu_btn_path


onready var menu_btn : Button = get_node(menu_btn_path)
onready var start_btn : Button = get_node(start_btn_path)
onready var death_sfx := $DeathSfx as AudioStreamPlayer


func _ready() -> void:
#	OS.window_maximized = true
	menu_btn.connect("pressed", self, "_on_MenuBtn_pressed")
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	Globals.connect("show_game_over", self, "_on_show_game_over")


func _on_show_game_over() -> void:
	BackgroundMusic.stream_paused = true
	death_sfx.play()
	show()


func _on_StartBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	SceneChanger.change_scene_reload()
	Globals.reset_is_game_over()
	#get_tree().reload_current_scene()


func _on_MenuBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
	Globals.reset_is_game_over()
	#get_tree().change_scene("res://src/Menu/Menu.tscn")
