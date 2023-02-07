tool


extends Button

export (PackedScene) var target_scene
export(NodePath) var level_image_tr_path
export(NodePath) var title_label_path
export(Texture) var level_image setget _set_level_image
export(String) var title setget _set_title


onready var level_image_tr := get_node(level_image_tr_path) as TextureRect
onready var title_label := get_node(title_label_path) as Label


func _ready() -> void:
	_set_level_image(level_image)
	_set_title(title)
	connect("pressed", self, "_on_pressed")


func _set_level_image(new_value : Texture) -> void:
	level_image = new_value
	if level_image_tr:
		level_image_tr.texture = level_image


func _set_title(new_value : String) -> void:
	title = new_value
	if title_label:
		title_label.text = title


func _on_pressed() -> void:
	if target_scene:
		SceneChanger.change_scene_to(target_scene)
