extends Node


var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")


onready var player := $Game/YSort/Player as KinematicBody2D
onready var ui_canvas_layer := $UI as CanvasLayer
onready var trigger_zone := $Game/TriggerZone as Area2D


func _ready() -> void:
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	player.animation_tree.set("parameters/Idle/blend_position", player.input_vector)
	trigger_zone.connect("body_entered", self, "_on_TriggerZone_body_entered")
	get_tree().create_timer(0.5).connect("timeout", self, "_dialogue_1")


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_enable_inputs")
	dialogue_inst.speaker = "Anunciante"
	dialogue_inst.dialogues = [
		"Atención, les informamos a nuestros alumnos que la primer clase del Platziverso esta por comenzar, porfavor dirijanse al edificio principal lo más rápido posible",
		"Para los despistados, les recuerdo que pueden moverse presionando las teclas [img=18]assets/images/keyboard/w.png[/img][img=18]assets/images/keyboard/a.png[/img][img=18]assets/images/keyboard/s.png[/img][img=18]assets/images/keyboard/d.png[/img]"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	var dialogue_inst = dialogue_scene.instance()
	Globals.disable_inputs = true
	dialogue_inst.connect("finished", self, "_enable_inputs")
	dialogue_inst.speaker = "Anunciante"
	dialogue_inst.dialogues = [
		"Tambien les recordamos que para moverse entre los niveles pueden utilizar los paneles de teletransporte",
		"Solo basta caminar encima de estos para avanzar al siguiente nivel"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _enable_inputs() -> void:
	Globals.disable_inputs = false


func _on_TriggerZone_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		_dialogue_2()
		trigger_zone.queue_free()
