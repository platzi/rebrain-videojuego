extends Control

export(NodePath) var logo_tr_path
export(NodePath) var select_level_btn_path
export(NodePath) var customization_btn_path
export(NodePath) var settings_btn_path 
export(NodePath) var credits_btn_path 

onready var logo_tr := get_node(logo_tr_path) as TextureRect
onready var select_level_btn := get_node(select_level_btn_path) as Button
onready var customization_btn := get_node(customization_btn_path) as Button
onready var settings_btn := get_node(settings_btn_path) as Button
onready var credits_btn := get_node(credits_btn_path) as Button


func _ready() -> void:
	select_level_btn.connect("pressed", self, "_on_SelectLevelBtn_pressed")
	customization_btn.connect("pressed", self, "_on_CustomizationBtn_pressed")
	settings_btn.connect("pressed", self, "_on_SettingsBtn_pressed")
	
	_create_start_transition()
	
	$PlayerAP.play("Start")
	$LogoAP.play("Start")
	var config = ConfigFile.new()
	var err = config.load("user://re_brain_data.cfg")
#	if err == OK and config.get_value("Player", "has_saved", false):
#		start_btn.visible = true
#	else:
#		start_btn.visible = false


func _create_start_transition() -> void:
	var delay = 0
	for obj in [logo_tr, select_level_btn, customization_btn, credits_btn, settings_btn]:
		if obj.visible:
			_create_tween(obj, delay)
			delay += 0.2


func _create_tween(obj : Control, delay : float) -> Tween:
	var tween := Tween.new()
	tween.interpolate_property(obj, "rect_position:x", -450, -450, delay, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	tween.interpolate_property(obj, "rect_position:x", -450, obj.rect_position.x, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	add_child(tween)
	tween.start()
	return tween


func _on_SelectLevelBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/LevelSelectionMenu.tscn")


func _on_CustomizationBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/CustomizationMenu.tscn")


func _on_SubMenu_closed() -> void:
	#start_btn.grab_focus()
	#$MarginContainer/VBoxContainer/MarginContainer.modulate.a = 1.0
	$AnimationPlayer2.play("Show")


func _on_NewGameBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	var config = ConfigFile.new()
	config.save("user://re_brain_data.cfg")
	SceneChanger.change_scene("res://src/Levels/LevelHub.tscn")
	#get_tree().change_scene("res://test/LevelBaseTest.tscn")


func _on_StartBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	var config = ConfigFile.new()
	var err = config.load("user://re_brain_data.cfg")
	var last_level = ""
	if err == OK:
		last_level = config.get_value("Player", "last_level", "res://src/Levels/LevelHub.tscn")
	else:
		last_level = "res://src/Levels/LevelHub.tscn"
	SceneChanger.change_scene(last_level)
	#get_tree().change_scene(last_level)


func _on_SettingsBtn_pressed() -> void:
	#$AudioStreamPlayer2D.play()
	SceneChanger.change_scene("res://src/Menu/SettingsMenu.tscn")


func _on_CreditsBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	var credits_inst = load("res://src/Menu/Credits.tscn").instance()
	get_tree().current_scene.add_child(credits_inst)
	credits_inst.connect("close_credits", self, "_on_SubMenu_closed")
	#$MarginContainer/VBoxContainer/MarginContainer.modulate.a = 0.0
	$AnimationPlayer2.play("Hide")
