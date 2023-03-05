tool


extends MarginContainer


class_name ScriptingNodeSlot


const COLORS = [
	Color("5aff00"),
	Color("ff0000"),
	Color("ffaa00"),
	Color("00aacc"),
	Color("cc99ff")
]
const ICONS = [
	preload("res://assets/images/scripting/scripting_icon_run.png"),
	preload("res://assets/images/scripting/scripting_icon_entity.png"),
	preload("res://assets/images/scripting/scripting_icon_string.png"),
	preload("res://assets/images/scripting/scripting_icon_number.png"),
	preload("res://assets/images/scripting/scripting_icon_bool.png")
]


var left_enabled : bool setget _set_left_enabled
var left_type : int setget _set_left_type
var left_tag : String setget _set_left_tag
var left_show_input : bool setget _set_left_show_input
var left_number_min := 0 setget _set_left_number_min
var left_number_max := 100 setget _set_left_number_max
var left_input_value := ""

var right_enabled : bool setget _set_right_enabled
var right_type : int setget _set_right_type
var right_tag : String setget _set_right_tag
var right_show_input : bool setget _set_right_show_input
var right_number_min := 0 setget _set_right_number_min
var right_number_max := 100 setget _set_right_number_max
var right_input_value := ""

var left_color : Color
var right_color : Color


onready var left_icon_tr := $HBoxContainer/InputHBC/LeftIconTR as TextureRect
onready var left_tag_label := $HBoxContainer/InputHBC/LeftTagLabel as Label
onready var right_icon_tr := $HBoxContainer/OutputHBC/RightIconTR as TextureRect
onready var right_tag_label := $HBoxContainer/OutputHBC/RightTagLabel as Label

onready var text_input_le := $HBoxContainer/InputHBC/TextInputLE as LineEdit
onready var number_input_sb := $HBoxContainer/InputHBC/NumberInputSB as SpinBox
onready var boolean_input_cb := $HBoxContainer/InputHBC/BooleanInputCB as CheckBox
onready var entity_input_ob := $HBoxContainer/InputHBC/EntityInputOB as OptionButton

onready var text_output_le := $HBoxContainer/OutputHBC/TextOutputLE as LineEdit
onready var number_output_sb := $HBoxContainer/OutputHBC/NumberOutputSB as SpinBox
onready var boolean_output_cb := $HBoxContainer/OutputHBC/BooleanOutputCB as CheckBox
onready var entity_output_ob := $HBoxContainer/OutputHBC/EntityOutputOB as OptionButton


var _is_ready := false


func _ready() -> void:
	_is_ready = true
	update_slot()
	_set_left_number_min(left_number_min)
	_set_left_number_max(left_number_max)
	_set_right_number_min(right_number_min)
	_set_right_number_max(right_number_max)
	_set_left_input_value(left_input_value)
	_set_right_input_value(right_input_value)


func _get_property_list() -> Array:
	var properties := []
	properties.append({
		name = "Left",
		type = TYPE_NIL,
		hint_string = "left_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "left_enabled",
		type = TYPE_BOOL
	})
	properties.append({
		name = "left_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Run, Entity, String, Number, Boolean"
	})
	properties.append({
		name = "left_tag",
		type = TYPE_STRING
	})
	properties.append({
		name = "left_show_input",
		type = TYPE_BOOL
	})
	properties.append({
		name = "left_number_min",
		type = TYPE_INT
	})
	properties.append({
		name = "left_number_max",
		type = TYPE_INT
	})
	properties.append({
		name = "Right",
		type = TYPE_NIL,
		hint_string = "right_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "right_enabled",
		type = TYPE_BOOL
	})
	properties.append({
		name = "right_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Run, Entity, String, Number, Boolean"
	})
	properties.append({
		name = "right_tag",
		type = TYPE_STRING
	})
	properties.append({
		name = "right_show_input",
		type = TYPE_BOOL
	})
	properties.append({
		name = "right_number_min",
		type = TYPE_INT
	})
	properties.append({
		name = "right_number_max",
		type = TYPE_INT
	})
	return properties


func hide_left_input() -> void:
	_set_left_input_visible(false)


func show_left_input() -> void:
	_set_left_input_visible(true)


func get_left_input_value() -> String:
	match left_type:
		1:
			return str(entity_input_ob.selected)
		2:
			return text_input_le.text
		3:
			return str(number_input_sb.value)
		4:
			return "true" if boolean_input_cb.pressed else "false"
	return ""


func get_right_input_value() -> String:
	match right_type:
		1:
			return str(entity_output_ob.selected)
		2:
			return text_output_le.text
		3:
			return str(number_output_sb.value)
		4:
			return "true" if boolean_output_cb.pressed else "false"
	return ""


func _set_left_input_visible(value : bool) -> void:
	if !left_enabled or !left_show_input:
		return
	match left_type:
		1:
			entity_input_ob.visible = value
		2:
			text_input_le.visible = value
		3:
			number_input_sb.visible = value
		4:
			boolean_input_cb.visible = value


func _set_left_input_value(value) -> void:
	match left_type:
		1:
			entity_input_ob.selected = int(value)
		2:
			text_input_le.text = value
		3:
			number_input_sb.value = int(value)
		4:
			boolean_input_cb.pressed = value == "true"


func _set_right_input_value(value) -> void:
	match right_type:
		1:
			entity_output_ob.selected = int(value)
		2:
			text_output_le.text = value
		3:
			number_output_sb.value = int(value)
		4:
			boolean_output_cb.pressed = value == "true"


func update_slot() -> void:
	if !_is_ready:
		return
	
	left_color = _get_color(left_type)
	left_icon_tr.texture = _get_icon(left_type)
	left_tag_label.text = left_tag
	right_color = _get_color(right_type)
	right_icon_tr.texture = _get_icon(right_type)
	right_tag_label.text = right_tag
	
	_deactivate_inputs()
	_activate_input()
	
	_deactivate_outputs()
	_activate_output()
	
	left_icon_tr.visible = left_enabled
	left_tag_label.visible = left_enabled && left_tag != ""
	right_icon_tr.visible = right_enabled
	right_tag_label.visible = right_enabled && right_tag != ""
	
	if get_parent():
		get_parent().update_slots()


func _deactivate_inputs() -> void:
	text_input_le.visible = false
	number_input_sb.visible = false
	boolean_input_cb.visible = false
	entity_input_ob.visible = false


func _activate_input() -> void:
	if !left_enabled or !left_show_input:
		return
	match left_type:
		1:
			entity_input_ob.visible = true
		2:
			text_input_le.visible = true
		3:
			number_input_sb.visible = true
		4:
			boolean_input_cb.visible = true


func _deactivate_outputs() -> void:
	text_output_le.visible = false
	number_output_sb.visible = false
	boolean_output_cb.visible = false
	entity_output_ob.visible = false


func _activate_output() -> void:
	if !right_enabled or !right_show_input:
		return
	match right_type:
		1:
			entity_output_ob.visible = true
		2:
			text_output_le.visible = true
		3:
			number_output_sb.visible = true
		4:
			boolean_output_cb.visible = true


func _get_color(type : int):
	if !COLORS[type]:
		return Color.black
	return COLORS[type]


func _get_icon(type : int):
	if !ICONS[type]:
		return null
	return ICONS[type]


func _set_left_enabled(new_value : bool) -> void:
	left_enabled = new_value
	update_slot()


func _set_left_type(new_value : int) -> void:
	left_type = new_value
	update_slot()


func _set_left_tag(new_value : String) -> void:
	left_tag = new_value
	update_slot()


func _set_left_show_input(new_value : bool) -> void:
	left_show_input = new_value
	update_slot()


func _set_left_number_min(new_value : int) -> void:
	left_number_min = new_value
	if _is_ready:
		number_input_sb.min_value = new_value


func _set_left_number_max(new_value : int) -> void:
	left_number_max = new_value
	if _is_ready:
		number_input_sb.max_value = new_value


func _set_right_enabled(new_value : bool) -> void:
	right_enabled = new_value
	update_slot()


func _set_right_type(new_value : int) -> void:
	right_type = new_value
	update_slot()


func _set_right_tag(new_value : String) -> void:
	right_tag = new_value
	update_slot()


func _set_right_show_input(new_value : bool) -> void:
	right_show_input = new_value
	update_slot()


func _set_right_number_min(new_value : int) -> void:
	right_number_min = new_value
	if _is_ready:
		number_output_sb.min_value = new_value


func _set_right_number_max(new_value : int) -> void:
	right_number_max = new_value
	if _is_ready:
		number_output_sb.max_value = new_value
