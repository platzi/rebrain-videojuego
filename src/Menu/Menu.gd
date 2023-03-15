extends Control


const HAIR_STYLES = [
	preload("res://assets/images/backgrounds/main-menu-player-hair-02.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-01.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-03.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-04.png"),
	null
]


export(NodePath) var player_tr_path
export(NodePath) var player_hair_tr_path
export(NodePath) var logo_tr_path
export(NodePath) var start_btn_path
export(NodePath) var select_level_btn_path
export(NodePath) var customization_btn_path
export(NodePath) var settings_btn_path 
export(NodePath) var credits_btn_path 


onready var player_tr := get_node(player_tr_path) as TextureRect
onready var player_hair_tr := get_node(player_hair_tr_path) as TextureRect


onready var logo_tr := get_node(logo_tr_path) as TextureRect
onready var start_btn := get_node(start_btn_path) as Button
onready var select_level_btn := get_node(select_level_btn_path) as Button
onready var customization_btn := get_node(customization_btn_path) as Button
onready var settings_btn := get_node(settings_btn_path) as Button
onready var credits_btn := get_node(credits_btn_path) as Button


func _ready() -> void:
	BackgroundMusic.play_menu_bgm()
	
	start_btn.connect("pressed", self, "_on_StartBtn_pressed")
	select_level_btn.connect("pressed", self, "_on_SelectLevelBtn_pressed")
	customization_btn.connect("pressed", self, "_on_CustomizationBtn_pressed")
	settings_btn.connect("pressed", self, "_on_SettingsBtn_pressed")
	
	$PlayerAP.play("Start")
	$LogoAP.play("Start")
	if !SaveManager.save_exists:
		start_btn.visible = true
	else:
		start_btn.visible = false
		select_level_btn.visible = true
		customization_btn.visible = true
	_load_avatar()
	yield(get_tree(), "idle_frame")
	_create_start_transition()


func _load_avatar() -> void:
	player_hair_tr.texture = HAIR_STYLES[SaveManager.save_data["customization"]["hair_style"]]
	player_hair_tr.material.set_shader_param("HAIR_COLOR", Customization.HAIR_COLORS[SaveManager.save_data["customization"]["hair_color"]])
	player_tr.material.set_shader_param("SKIN_COLOR", Customization.SKIN_COLORS[SaveManager.save_data["customization"]["skin_color"]])
	player_tr.material.set_shader_param("SHIRT_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["shirt_color"]])
	player_tr.material.set_shader_param("PANTS_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["pants_color"]])
	player_tr.material.set_shader_param("SHOES_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["shoes_color"]])


func _create_start_transition() -> void:
	var delay = 0
	for obj in [logo_tr, start_btn, select_level_btn, customization_btn, credits_btn, settings_btn]:
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


func _on_StartBtn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	var config = ConfigFile.new()
	var err = config.load("user://re_brain_data.cfg")
	SceneChanger.change_scene("res://src/Menu/CustomizationMenu.tscn")


func _on_SelectLevelBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/LevelSelectionMenu.tscn")


func _on_CustomizationBtn_pressed() -> void:
	SceneChanger.change_scene("res://src/Menu/CustomizationMenu.tscn")


func _on_SubMenu_closed() -> void:
	#start_btn.grab_focus()
	#$MarginContainer/VBoxContainer/MarginContainer.modulate.a = 1.0
	$AnimationPlayer2.play("Show")


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
