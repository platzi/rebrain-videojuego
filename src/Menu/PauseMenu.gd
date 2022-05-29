extends Control

export(NodePath) var start_btn_path 
export(NodePath) var menu_btn_path


onready var menu_btn : Button = get_node(menu_btn_path)
onready var start_btn : Button = get_node(start_btn_path)


func _ready() -> void:
	start_btn.grab_focus()
	start_btn.focus_neighbour_top = menu_btn.get_path()
	menu_btn.focus_neighbour_bottom = start_btn.get_path()
	menu_btn.connect("pressed", self, "_on_MenuBtn_pressed")
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")


func _input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.is_pressed():
		visible = not visible


func _on_StartBtn_pressed() -> void:
	SceneChanger.change_scene_reload()


func _on_MenuBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/Menu.tscn")
