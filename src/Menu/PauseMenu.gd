extends Control

export(NodePath) var start_btn_path 
export(NodePath) var menu_btn_path


onready var menu_btn : Button = get_node(menu_btn_path)
onready var start_btn : Button = get_node(start_btn_path)


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	menu_btn.connect("pressed", self, "_on_MenuBtn_pressed")
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")


func _input(event):
	if not Globals.is_game_over:
		if event is InputEventKey and event.scancode == KEY_ESCAPE and event.is_pressed():
			visible = not visible
			Globals.set_pause_game(not Globals.is_game_paused)
			get_tree().paused = not get_tree().paused


func _on_StartBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	get_tree().paused = false
	SceneChanger.change_scene_reload()


func _on_MenuBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	get_tree().paused = false
	SceneChanger.change_scene("res://src/Menu/Menu.tscn", true)
