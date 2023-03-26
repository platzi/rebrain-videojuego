extends Node


var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")


onready var player := $Game/YSort/Player as KinematicBody2D
onready var ui_canvas_layer := $UI as CanvasLayer
onready var trigger_zone := $Game/TriggerZone as Area2D


func _ready() -> void:
	BackgroundMusic.play_game_bgm_01()
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.direction = 270
	trigger_zone.connect("body_entered", self, "_on_TriggerZone_body_entered")
	get_tree().create_timer(0.5).connect("timeout", self, "_dialogue_1")


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_enable_inputs")
	dialogue_inst.speaker = "Anunciante"
	dialogue_inst.dialogues = [
		"Intro01.Dialogue1.01",
		"Intro01.Dialogue1.02"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	var dialogue_inst = dialogue_scene.instance()
	Globals.disable_inputs = true
	dialogue_inst.connect("finished", self, "_enable_inputs")
	dialogue_inst.speaker = "Anunciante"
	dialogue_inst.dialogues = [
		"Intro01.Dialogue2.01",
		"Intro01.Dialogue2.02"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _enable_inputs() -> void:
	Globals.disable_inputs = false


func _on_TriggerZone_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		_dialogue_2()
		trigger_zone.queue_free()
