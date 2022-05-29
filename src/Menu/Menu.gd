extends Control

export(NodePath) var start_btn_path 
export(NodePath) var options_btn_path 
export(NodePath) var credits_btn_path 

onready var start_btn : Button = get_node(start_btn_path)
onready var options_btn : Button = get_node(options_btn_path)
onready var credits_btn : Button = get_node(credits_btn_path)


func _on_SubMenu_closed() -> void:
	start_btn.grab_focus()


func _on_StartBtn_pressed() -> void:
	get_tree().change_scene("")


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
	
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	options_btn.connect("pressed", self, "_on_OptionsBtn_pressed")
	credits_btn.connect("pressed", self, "_on_CreditsBtn_pressed")
	
	$AnimationPlayer.play("Intro")
