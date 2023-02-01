extends Control


enum PROPERTY_TYPE {
	HAIR
}


export(Array, Texture) var hair_textures
export(Array, Color) var hair_colors
export(Array, Color) var skin_colors
export(Array, Color) var clothes_colors
export(NodePath) var hair_gc_path
export(NodePath) var hair_color_gc_path
export(NodePath) var skin_color_gc_path
export(NodePath) var shirt_color_gc_path
export(NodePath) var pants_color_gc_path
export(NodePath) var shoes_color_gc_path
export(NodePath) var back_btn_path


onready var hair_color_gc : GridContainer = get_node(hair_color_gc_path)
onready var hair_gc : GridContainer = get_node(hair_gc_path)
onready var skin_color_gc : GridContainer = get_node(skin_color_gc_path)
onready var shirt_color_gc : GridContainer = get_node(shirt_color_gc_path)
onready var pants_color_gc : GridContainer = get_node(pants_color_gc_path)
onready var shoes_color_gc : GridContainer = get_node(shoes_color_gc_path)
onready var back_btn : Button = get_node(back_btn_path)


func _ready():
	$PlayerAP.play("Rotate")
	
#	hair_hbc.get_node("PropertyNextBtn").connect("pressed", self, "_on_property_prev_btn_pressed", [hair_hbc, PROPERTY_TYPE.HAIR])
	back_btn.connect("pressed", self, "_on_BackBtn_pressed")
	_create_property_buttons(hair_textures, hair_gc)
	_create_property_buttons_color(hair_colors, hair_color_gc)
	_create_property_buttons_color(skin_colors, skin_color_gc)
	_create_property_buttons_color(clothes_colors, shirt_color_gc)
	_create_property_buttons_color(clothes_colors, pants_color_gc)
	_create_property_buttons_color(clothes_colors, shoes_color_gc)


func _create_property_buttons(properties : Array, parent : GridContainer) -> void:
	var buttons := []
	for i in len(properties):
		var button = _create_property_button(str(i + 1))
		buttons.append(button)
		parent.add_child(button)
	for button in buttons:
		button.connect("pressed", self, "_on_property_button_pressed", [button, buttons])


func _create_property_buttons_color(colors : Array, parent : GridContainer) -> void:
	var buttons := []
	for color in colors:
		var button = _create_property_button_color(color)
		buttons.append(button)
		parent.add_child(button)
	for button in buttons:
		button.connect("pressed", self, "_on_property_button_pressed", [button, buttons])


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


func _on_property_button_pressed(button : Button, buttons : Array) -> void:
	for other_button in buttons:
		other_button.pressed = false
		other_button.disabled = false
	button.disabled = true


func _on_BackBtn_pressed() -> void:
	 SceneChanger.change_scene("res://src/Menu/Menu.tscn")
