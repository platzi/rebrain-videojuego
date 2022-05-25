extends Control

onready var startBtn := $VBoxContainer/StartBtn
onready var optionsBtn := $VBoxContainer/OptionsBtn
onready var creditsBtn := $VBoxContainer/CreditsBtn
onready var exitBtn := $VBoxContainer/ExitBtn

func _on_SubMenu_closed():
	startBtn.grab_focus()

func _on_StartBtn_pressed():
	get_tree().change_scene("")

func _on_OptionsBtn_pressed():
	var optionsInst = load("res://src/Menu/Options.tscn").instance()
	get_tree().current_scene.add_child(optionsInst)
	optionsInst.connect("close_options", self, "_on_SubMenu_closed")

func _on_CreditsBtn_pressed():
	var creditsInst = load("res://src/Menu/Credits.tscn").instance()
	get_tree().current_scene.add_child(creditsInst)
	#startBtn.grab_focus()
	creditsInst.connect("close_credits", self, "_on_SubMenu_closed")

func _on_ExitBtn_pressed():
	get_tree().quit()

func _ready():
	startBtn.grab_focus()
	exitBtn.focus_neighbour_bottom = startBtn.get_path()
	
	startBtn.connect("pressed", self, "_on_StartBtn_pressed")
	optionsBtn.connect("pressed", self, "_on_OptionsBtn_pressed")
	creditsBtn.connect("pressed", self, "_on_CreditsBtn_pressed")
	exitBtn.connect("pressed", self, "_on_ExitBtn_pressed")
	
