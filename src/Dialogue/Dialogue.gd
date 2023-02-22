extends Control

signal finished

export(String) var speaker : String
export(Array, String, MULTILINE) var dialogues : Array

onready var animation_player : AnimationPlayer = $AnimationPlayer 
onready var characters_timer : Timer = $CharactersTimer
onready var rich_text_label : RichTextLabel = $MarginContainer/PanelContainer/VBoxContainer/RichTextLabel
onready var speaker_label := $MarginContainer/PanelContainer/VBoxContainer/SpeakerLabel as Label

var current_dialogue_index = 0
var hacker_mode := false


var _disabled = false

func _ready():
	characters_timer.connect("timeout", self, "_show_next_character")
	animation_player.play("Open")
	if speaker == "hacker":
		hacker_mode = true
	else:
		set_process(false)
		speaker_label.text = speaker
	rich_text_label.bbcode_text = dialogues[current_dialogue_index]
	characters_timer.start(0.02)


func _process(_delta : float) -> void:
	var text := ""
	for i in range(6):
		text = text + char(65 + randi() % 26)
	speaker_label.text = text

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
			animation_player.connect("animation_finished", self, "_destroy")
			_disabled = true
			emit_signal("finished")
	else:
		rich_text_label.visible_characters = rich_text_label.text.length()


func _destroy(anim : String) -> void:
	queue_free()


func _show_next_character() -> void:
	rich_text_label.visible_characters += 1
