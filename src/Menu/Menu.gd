extends Control


onready var start_btn := $VBoxContainer/StartBtn
onready var options_btn := $VBoxContainer/OptionsBtn
onready var credits_btn := $VBoxContainer/CreditsBtn
onready var exit_btn := $VBoxContainer/ExitBtn


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


func _on_ExitBtn_pressed() -> void:
	get_tree().quit()


func _ready() -> void:
	start_btn.grab_focus()
	exit_btn.focus_neighbour_bottom = start_btn.get_path()
	
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	options_btn.connect("pressed", self, "_on_OptionsBtn_pressed")
	credits_btn.connect("pressed", self, "_on_CreditsBtn_pressed")
	exit_btn.connect("pressed", self, "_on_ExitBtn_pressed")
