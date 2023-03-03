tool

extends GraphNode

class_name ScriptingNode

signal run_finished

export(String) var type
export(String) var tag setget _set_tag
export(String) var subtag setget _set_subtag
export(Texture) var icon setget _set_icon

var _params := []

const _disabled_theme := preload("res://assets/themes/scripting_node_disabled_theme.tres")
const _theme := preload("res://assets/themes/scripting_node_theme.tres")

onready var _is_ready = true

onready var title_icon := $TitleMC/TitleMC/TitleHBC/TitleIcon
onready var title_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/TitleLabel
onready var subtitle_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/SubtitleLabel

var disabled = false setget _set_disabled

func _ready() -> void:
	theme = _theme
	update_slots()
	_set_icon(icon)
	_set_tag(tag)
	_set_subtag(subtag)


func _process(_delta : float) -> void:
	if !Engine.editor_hint and !Globals.DEBUG and disabled:
		selected = false


func update_slots() -> void:
	for i in get_child_count():
		var child = get_child(i)
		if child is ScriptingNodeSlot:
			set_slot(
				i,
				child.left_enabled,
				child.left_type,
				child.left_color,
				child.right_enabled,
				child.right_type,
				child.right_color
			)


func get_inputs() -> Dictionary:
	var dict := {}
	for i in get_child_count():
		var child = get_child(i)
		if child is ScriptingNodeSlot and child.left_enabled and child.left_type != 0:
			dict[str(i - 1)] = child.get_left_input_value()
	return dict


func get_outputs() -> Dictionary:
	var dict := {}
	for i in get_child_count():
		var child = get_child(i)
		if child is ScriptingNodeSlot and child.right_enabled and child.right_type != 0:
			dict[str(i - 1)] = child.get_right_input_value()
	return dict


func set_inputs(inputs : Dictionary) -> void:
	for i in inputs:
		var child = get_child(int(i) + 1)
		if child is ScriptingNodeSlot:
			child.left_input_value = inputs[i]


func set_outputs(inputs : Dictionary) -> void:
	for i in inputs:
		var child = get_child(int(i) + 1)
		if child is ScriptingNodeSlot:
			child.right_input_value = inputs[i]


func set_params(params : Array) -> void:
	_params = params
	if !_is_ready:
		return
	_set_params(_params)


func get_params() -> Array:
	return _get_params()


func _set_params(_param : Array) -> void:
	pass


func _get_params() -> Array:
	return []


func _set_tag(new_value : String) -> void:
	tag = new_value
	if _is_ready:
		title_label.text = tag


func _set_subtag(new_value : String) -> void:
	subtag = new_value
	if _is_ready:
		subtitle_label.text = subtag
		subtitle_label.visible = subtag != ""


func _set_icon(new_value : Texture) -> void:
	icon = new_value
	if _is_ready:
		title_icon.texture = new_value


func _set_disabled(new_value : bool) -> void:
	disabled = new_value
	if disabled:
		theme = _disabled_theme
	
