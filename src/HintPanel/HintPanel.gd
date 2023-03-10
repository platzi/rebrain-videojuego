extends Control


class_name HintPanel


signal closed


export(NodePath) var title_label_path : NodePath
export(NodePath) var content_container_path : NodePath
export(NodePath) var close_btn_path : NodePath


export var title : String setget _on_title_set


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var title_label := get_node(title_label_path) as Label
onready var content_container := get_node(content_container_path) as MarginContainer
onready var close_btn := get_node(close_btn_path) as Button


var hints := []
var hint_current := 0


func _ready():
	title_label.text = title
	animation_player.play("Open")
	close_btn.connect("pressed", self, "_on_CloseBtn_pressed")
	_add_hint()


func _add_hint() -> void:
	var hint : HintResource = hints.pop_back()
	print(hint.content)
	if hint == null:
		return
	var hbc := HBoxContainer.new()
	var tr := TextureRect.new()
	var rtl := RichTextLabel.new()
	tr.texture = hint.image if hint.image else null
	tr.expand = true
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.rect_min_size = Vector2(320.0, 186.0)
	rtl.bbcode_enabled = true
	rtl.bbcode_text = hint.content
	rtl.fit_content_height = true
	rtl.size_flags_horizontal = SIZE_EXPAND_FILL
	rtl.size_flags_vertical = SIZE_SHRINK_CENTER
	hbc.visible = content_container.get_child_count() == 0
	hbc.add_child(tr)
	hbc.add_child(rtl)
	hbc.add_constant_override("separation", 20)
	content_container.add_child(hbc)
	


func _on_CloseBtn_pressed() -> void:
	animation_player.play("Close")
	animation_player.connect("animation_finished", self, "_on_close_animation_finished", [], CONNECT_ONESHOT)


func _on_close_animation_finished(_anim : String) -> void:
	emit_signal("closed")
	queue_free()


func _on_title_set(new_value : String) -> void:
	title = new_value
