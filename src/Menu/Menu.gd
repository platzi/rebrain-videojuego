extends Control

export(NodePath) var new_game_path
export(NodePath) var start_btn_path 
export(NodePath) var options_btn_path 
export(NodePath) var credits_btn_path 

onready var new_game_btn : Button = get_node(new_game_path)
onready var start_btn : Button = get_node(start_btn_path)
onready var options_btn : Button = get_node(options_btn_path)
onready var credits_btn : Button = get_node(credits_btn_path)


func _on_SubMenu_closed() -> void:
	start_btn.grab_focus()


func _on_NewGameBtn_pressed() -> void:
	var config = ConfigFile.new()
	config.save("user://re_brain_data.cfg")
	SceneChanger.change_scene("res://src/Levels/LevelHub.tscn")
	#get_tree().change_scene("res://test/LevelBaseTest.tscn")


func _on_StartBtn_pressed() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://re_brain_data.cfg")
	var last_level = ""
	if err == OK:
		last_level = config.get_value("Player", "last_level", "res://src/Levels/LevelHub.tscn")
	else:
		last_level = "res://src/Levels/LevelHub.tscn"
	SceneChanger.change_scene(last_level)
	#get_tree().change_scene(last_level)


func _on_OptionsBtn_pressed() -> void:
	var options_inst = load("res://src/Menu/Options.tscn").instance()
	get_tree().current_scene.add_child(options_inst)
	options_inst.connect("close_options", self, "_on_SubMenu_closed")


func _on_CreditsBtn_pressed() -> void:
	var credits_inst = load("res://src/Menu/Credits.tscn").instance()
	get_tree().current_scene.add_child(credits_inst)
	credits_inst.connect("close_credits", self, "_on_SubMenu_closed")


func _ready() -> void:
#	OS.window_maximized = true
	start_btn.grab_focus()
	start_btn.focus_neighbour_top = credits_btn.get_path()
	credits_btn.focus_neighbour_bottom = start_btn.get_path()
	new_game_btn.connect("pressed", self, "_on_NewGameBtn_pressed")
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	options_btn.connect("pressed", self, "_on_OptionsBtn_pressed")
	credits_btn.connect("pressed", self, "_on_CreditsBtn_pressed")
	
	$AnimationPlayer.play("Intro")
