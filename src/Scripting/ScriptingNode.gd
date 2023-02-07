tool

class_name ScriptingNode
extends GraphNode

signal run_finished

export(Theme) var disabled_theme
export(String) var tag setget _set_tag
export(String) var subtag setget _set_subtag
export(Texture) var icon setget _set_icon

var _params := []

onready var _is_ready = true

onready var title_icon := $TitleMC/TitleMC/TitleHBC/TitleIcon
onready var title_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/TitleLabel
onready var subtitle_label := $TitleMC/TitleMC/TitleHBC/VBoxContainer/SubtitleLabel

var disabled = false setget _set_disabled
var type = "NONE"

func _ready() -> void:
	_set_icon(icon)
	_set_tag(tag)
	_set_subtag(subtag)


func _process(_delta : float) -> void:
	if !Engine.editor_hint and !Globals.DEBUG and disabled:
		selected = false


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
		theme = disabled_theme
	
