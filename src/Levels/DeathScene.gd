extends Control

export(NodePath) var start_btn_path 
export(NodePath) var menu_btn_path


onready var menu_btn : Button = get_node(menu_btn_path)
onready var start_btn : Button = get_node(start_btn_path)


func _on_StartBtn_pressed() -> void:
	get_tree().reload_current_scene()


func _on_MenuBtn_pressed() -> void:
	get_tree().change_scene("res://src/Menu/Menu.tscn")


func _ready() -> void:
#	OS.window_maximized = true
	start_btn.grab_focus()
	start_btn.focus_neighbour_top = menu_btn.get_path()
	menu_btn.focus_neighbour_bottom = start_btn.get_path()
	menu_btn.connect("pressed", self, "_on_MenuBtn_pressed")
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	Globals.connect("show_game_over", self, "show")