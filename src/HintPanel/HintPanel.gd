extends Control


class_name HintPanel


signal closed


export(NodePath) var title_label_path : NodePath
export(NodePath) var image_tr_path : NodePath
export(NodePath) var content_rtl_path : NodePath
export(NodePath) var close_btn_path : NodePath


export var title : String setget _on_title_set
export var image : Texture setget _on_image_set
export var content : String setget _on_content_set


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var title_label := get_node(title_label_path) as Label
onready var image_tr := get_node(image_tr_path) as TextureRect
onready var content_rtl := get_node(content_rtl_path) as RichTextLabel
onready var close_btn := get_node(close_btn_path) as Button


func _ready():
	image_tr.texture = image
	title_label.text = title
	content_rtl.bbcode_text = content
	animation_player.play("Open")
	close_btn.connect("pressed", self, "_on_CloseBtn_pressed")


func _on_CloseBtn_pressed() -> void:
	animation_player.play("Close")
	animation_player.connect("animation_finished", self, "_on_close_animation_finished", [], CONNECT_ONESHOT)


func _on_close_animation_finished(_anim : String) -> void:
	emit_signal("closed")
	queue_free()


func _on_title_set(new_value : String) -> void:
	title = new_value


func _on_image_set(new_value : StreamTexture) -> void:
	image = new_value


func _on_content_set(new_value : String) -> void:
	content = new_value
