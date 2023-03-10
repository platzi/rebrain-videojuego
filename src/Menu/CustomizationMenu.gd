extends Control


enum PROPERTY_TYPE {
	HAIR,
	HAIR_COLOR,
	SKIN_COLOR,
	SHIRT_COLOR,
	PANTS_COLOR,
	SHOES_COLOR
}


export(NodePath) var player_tr_path
export(NodePath) var hair_tr_path
export(NodePath) var name_le_path
export(NodePath) var hair_gc_path
export(NodePath) var hair_color_gc_path
export(NodePath) var skin_color_gc_path
export(NodePath) var shirt_color_gc_path
export(NodePath) var pants_color_gc_path
export(NodePath) var shoes_color_gc_path
export(NodePath) var save_btn_path
export(NodePath) var back_btn_path


onready var player_tr := get_node(player_tr_path) as TextureRect
onready var hair_tr := get_node(hair_tr_path) as TextureRect
onready var name_le := get_node(name_le_path) as LineEdit
onready var hair_gc := get_node(hair_gc_path) as GridContainer
onready var hair_color_gc := get_node(hair_color_gc_path) as GridContainer
onready var skin_color_gc := get_node(skin_color_gc_path) as GridContainer
onready var shirt_color_gc := get_node(shirt_color_gc_path) as GridContainer
onready var pants_color_gc := get_node(pants_color_gc_path) as GridContainer
onready var shoes_color_gc := get_node(shoes_color_gc_path) as GridContainer
onready var save_btn : Button = get_node(save_btn_path)
onready var back_btn : Button = get_node(back_btn_path)


var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")
var loaded := false
var selected_hair := 0
var selected_hair_color := 0
var selected_skin_color := 0
var selected_shirt_color := 0
var selected_pants_color := 7
var selected_shoes_color := 0


func _ready():
	$PlayerAP.play("Rotate")
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	save_btn.connect("pressed", self, "_on_SaveBtn_pressed")
	
	if !SaveManager.save_exists:
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.dialogues = [
			"Bienvendio al Platziverso, antes de comenzar porfavor crea tu avatar a tu gusto",
			"Cuando finalices, puedes presionar el botón Guardar para continuar hacía el metaverso"
		]
		add_child(dialogue_inst)
	else:
		loaded = true
		_load_data()
	
	_create_property_buttons(Customization.HAIR_STYLES, hair_gc, selected_hair, PROPERTY_TYPE.HAIR)
	_create_property_buttons_color(Customization.HAIR_COLORS, hair_color_gc, selected_hair_color, PROPERTY_TYPE.HAIR_COLOR)
	_create_property_buttons_color(Customization.SKIN_COLORS, skin_color_gc, selected_skin_color, PROPERTY_TYPE.SKIN_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, shirt_color_gc, selected_shirt_color, PROPERTY_TYPE.SHIRT_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, pants_color_gc, selected_pants_color, PROPERTY_TYPE.PANTS_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, shoes_color_gc, selected_shoes_color, PROPERTY_TYPE.SHOES_COLOR)
	_update_avatar()


func _load_data() -> void:
	name_le.text = SaveManager.save_data["customization"]["player_name"]
	selected_hair = SaveManager.save_data["customization"]["hair_style"]
	selected_hair_color = SaveManager.save_data["customization"]["hair_color"]
	selected_skin_color = SaveManager.save_data["customization"]["skin_color"]
	selected_shirt_color = SaveManager.save_data["customization"]["shirt_color"]
	selected_pants_color = SaveManager.save_data["customization"]["pants_color"]
	selected_shoes_color = SaveManager.save_data["customization"]["shoes_color"]


func _update_avatar() -> void:
	hair_tr.texture.atlas = Customization.HAIR_STYLES[selected_hair]
	hair_tr.material.set_shader_param("HAIR_COLOR", Customization.HAIR_COLORS[selected_hair_color])
	player_tr.material.set_shader_param("SKIN_COLOR", Customization.SKIN_COLORS[selected_skin_color])
	player_tr.material.set_shader_param("SHIRT_COLOR", Customization.CLOTHES_COLOR[selected_shirt_color])
	player_tr.material.set_shader_param("PANTS_COLOR", Customization.CLOTHES_COLOR[selected_pants_color])
	player_tr.material.set_shader_param("SHOES_COLOR", Customization.CLOTHES_COLOR[selected_shoes_color])


func _create_property_buttons(properties : Array, parent : GridContainer, selected : int, type : int) -> void:
	var buttons := []
	for i in len(properties):
		var button = _create_property_button(str(i + 1))
		if i == selected:
			button.pressed = true
			button.disabled = true
		buttons.append(button)
		parent.add_child(button)
	for i in len(buttons):
		var button = buttons[i]
		button.connect("pressed", self, "_on_property_button_pressed", [button, buttons, i, type])


func _create_property_buttons_color(colors : Array, parent : GridContainer, selected : int, type : int) -> void:
	var buttons := []
	for i in len(colors):
		var color = colors[i]
		var button = _create_property_button_color(color)
		if i == selected:
			button.pressed = true
			button.disabled = true
		buttons.append(button)
		parent.add_child(button)
	for i in len(buttons):
		var button = buttons[i]
		button.connect("pressed", self, "_on_property_button_pressed", [button, buttons, i, type])


func _create_property_button(text : String) -> Button:
	var button = Button.new()
	# Set properties
	button.text = text
	button.toggle_mode = true
	button.focus_mode = FOCUS_NONE
	button.mouse_filter = MOUSE_FILTER_PASS
	button.rect_min_size = Vector2(30.0, 30.0)
	button.size_flags_horizontal = SIZE_EXPAND + SIZE_SHRINK_CENTER
	return button


func _create_property_button_color(color : Color) -> Button:
	var button = Button.new()
	var colorRect = ColorRect.new()
	# Set properties
	button.toggle_mode = true
	button.focus_mode = FOCUS_NONE
	button.mouse_filter = MOUSE_FILTER_PASS
	button.rect_min_size = Vector2(30.0, 30.0)
	button.size_flags_horizontal = SIZE_EXPAND + SIZE_SHRINK_CENTER
	colorRect.color = color
	colorRect.mouse_filter = MOUSE_FILTER_IGNORE
	colorRect.set_anchors_preset(PRESET_WIDE)
	colorRect.margin_left = 8
	colorRect.margin_top = 8
	colorRect.margin_bottom = -8
	colorRect.margin_right = -8
	button.add_child(colorRect)
	return button


func _on_property_button_pressed(button : Button, buttons : Array, index : int, type : int) -> void:
	for other_button in buttons:
		other_button.pressed = false
		other_button.disabled = false
	button.disabled = true
	match type:
		PROPERTY_TYPE.HAIR:
			selected_hair = index
		PROPERTY_TYPE.HAIR_COLOR:
			selected_hair_color = index
		PROPERTY_TYPE.SKIN_COLOR:
			selected_skin_color = index
		PROPERTY_TYPE.SHIRT_COLOR:
			selected_shirt_color = index
		PROPERTY_TYPE.PANTS_COLOR:
			selected_pants_color = index
		PROPERTY_TYPE.SHOES_COLOR:
			selected_shoes_color = index
	_update_avatar()


func _on_SaveBtn_pressed() -> void:
	if name_le.text.dedent() == "":
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.dialogues = [
			"Es necesario ingresar un nombre antes de continuar"
		]
		add_child(dialogue_inst)
		return
	SaveManager.save_data["customization"]["player_name"] = name_le.text.dedent()
	SaveManager.save_data["customization"]["hair_style"] = selected_hair
	SaveManager.save_data["customization"]["hair_color"] = selected_hair_color
	SaveManager.save_data["customization"]["skin_color"] = selected_skin_color
	SaveManager.save_data["customization"]["shirt_color"] = selected_shirt_color
	SaveManager.save_data["customization"]["pants_color"] = selected_pants_color
	SaveManager.save_data["customization"]["shoes_color"] = selected_shoes_color
	SaveManager.save()
	if !loaded:
		SceneChanger.change_scene("res://src/Levels/Intro/Intro01.tscn")
	else:
		SceneChanger.change_scene("res://src/Menu/Menu.tscn")


func _on_BackBtn_pressed() -> void:
	 SceneChanger.change_scene("res://src/Menu/Menu.tscn")
