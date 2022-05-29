extends Control

signal finished

export(Array, String, MULTILINE) var dialogues : Array

onready var animation_player : AnimationPlayer = $AnimationPlayer 
onready var characters_timer : Timer = $CharactersTimer
onready var rich_text_label : RichTextLabel = $PanelContainer/RichTextLabel

var current_dialogue_index = 0

var _disabled = false

func _ready():
	characters_timer.connect("timeout", self, "_show_next_character")
	
	animation_player.play("Open")
	rich_text_label.bbcode_text = dialogues[current_dialogue_index]
	characters_timer.start(0.02)

	animation_player.connect("animation_finished", self, "_destroy")


func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			skip()


func skip() -> void:
	if _disabled:
		return
	if rich_text_label.visible_characters >= rich_text_label.text.length():
		current_dialogue_index += 1
		if current_dialogue_index < dialogues.size():
			rich_text_label.visible_characters = 0
			rich_text_label.bbcode_text = dialogues[current_dialogue_index]
		else:
			animation_player.play("Close")
			_disabled = true
			emit_signal("finished")
	else:
		rich_text_label.visible_characters = rich_text_label.text.length()


func _destroy(anim : String) -> void:
	if anim == "Close":
		queue_free()


func _show_next_character() -> void:
	rich_text_label.visible_characters += 1
