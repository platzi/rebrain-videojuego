tool

class_name ScriptingNode
extends GraphNode

signal run_finished

export(String) var tag setget _set_tag
export(String) var subtag setget _set_subtag
export(Texture) var icon setget _set_icon

var _params = []

onready var _is_ready = true

onready var title_icon := $TitleMC/TitleMC/TitleHBC/TitleIcon
onready var title_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/TitleLabel
onready var subtitle_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/SubtitleLabel

var type = "NONE"

func _ready() -> void:
	print(get_children())
	_set_icon(icon)
	_set_tag(tag)
	_set_subtag(subtag)
	yield(get_tree().root, "ready")
	if _params.size() > 0:
		_set_params(_params)


func set_params(params : Array) -> void:
	_params = params
	if !_is_ready:
		return
	_set_params(params)


func get_params() -> Array:
	return _get_params()


func _set_params(param : Array) -> void:
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
