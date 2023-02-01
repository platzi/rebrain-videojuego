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
export(NodePath) var hair_gc_path
export(NodePath) var hair_color_gc_path
export(NodePath) var skin_color_gc_path
export(NodePath) var shirt_color_gc_path
export(NodePath) var pants_color_gc_path
export(NodePath) var shoes_color_gc_path
export(NodePath) var back_btn_path


onready var player_tr : TextureRect = get_node(player_tr_path)
onready var hair_tr : TextureRect = get_node(hair_tr_path)
onready var hair_gc : GridContainer = get_node(hair_gc_path)
onready var hair_color_gc : GridContainer = get_node(hair_color_gc_path)
onready var skin_color_gc : GridContainer = get_node(skin_color_gc_path)
onready var shirt_color_gc : GridContainer = get_node(shirt_color_gc_path)
onready var pants_color_gc : GridContainer = get_node(pants_color_gc_path)
onready var shoes_color_gc : GridContainer = get_node(shoes_color_gc_path)
onready var back_btn : Button = get_node(back_btn_path)


var selected_hair := 0
var selected_hair_color := 0
var selected_skin_color := 0
var selected_shirt_color := 0
var selected_pants_color := 7
var selected_shoes_color := 0


func _ready():
	$PlayerAP.play("Rotate")
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	_create_property_buttons(Customization.HAIR_STYLES, hair_gc, selected_hair, PROPERTY_TYPE.HAIR)
	_create_property_buttons_color(Customization.HAIR_COLORS, hair_color_gc, selected_hair_color, PROPERTY_TYPE.HAIR_COLOR)
	_create_property_buttons_color(Customization.SKIN_COLORS, skin_color_gc, selected_skin_color, PROPERTY_TYPE.SKIN_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, shirt_color_gc, selected_shirt_color, PROPERTY_TYPE.SHIRT_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, pants_color_gc, selected_pants_color, PROPERTY_TYPE.PANTS_COLOR)
	_create_property_buttons_color(Customization.CLOTHES_COLOR, shoes_color_gc, selected_shoes_color, PROPERTY_TYPE.SHOES_COLOR)
	_update_avatar()


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
	button.rect_min_size = Vector2(30.0, 30.0)
	button.size_flags_horizontal = SIZE_EXPAND + SIZE_SHRINK_CENTER
	return button


func _create_property_button_color(color : Color) -> Button:
	var button = Button.new()
	var colorRect = ColorRect.new()
	# Set properties
	button.toggle_mode = true
	button.focus_mode = FOCUS_NONE
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


func _on_BackBtn_pressed() -> void:
	 SceneChanger.change_scene("res://src/Menu/Menu.tscn")
