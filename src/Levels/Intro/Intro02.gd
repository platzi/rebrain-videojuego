extends Node


var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")
var hint_panel_scene := load("res://src/HintPanel/HintPanel.tscn")


export(Array, NodePath) var npc_paths


onready var player := $Entities/YSort/Player as KinematicBody2D
onready var ui_canvas_layer := $UI as CanvasLayer
onready var trigger_zone := $TriggerZone as Area2D
onready var flash_animation_player := $FlashAnimationPlayer as AnimationPlayer
onready var teleporter := $Entities/YSort/Teleporter as Entity
onready var shake_sfx := $ShakeSfx as AudioStreamPlayer


func _ready() -> void:
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	trigger_zone.connect("body_entered", self, "_on_TriggerZone_body_entered")
	get_tree().create_timer(0.5).connect("timeout", self, "_dialogue_1")


func _delete_npcs() -> void:
	for npc_path in npc_paths:
		var npc := get_node(npc_path) as Entity
		npc.queue_free()


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_on_dialogue_1_finished")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue1.01",
		"Intro02.Dialogue1.02",
		"Intro02.Dialogue1.03",
		"Intro02.Dialogue1.04",
		"Intro02.Dialogue1.05",
		"Intro02.Dialogue1.06"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_1")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue2.01",
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_2")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue3.01",
		"Intro02.Dialogue3.02",
		"Intro02.Dialogue3.03",
		"Intro02.Dialogue3.04"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_4(entity : Entity) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_3")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue4.01",
		"Intro02.Dialogue4.02",
		"Intro02.Dialogue4.03"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_5(node : ScriptingNode) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_4")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue5.01",
		"Intro02.Dialogue5.02",
		"Intro02.Dialogue5.03",
		"Intro02.Dialogue5.04",
		"Intro02.Dialogue5.05",
		"Intro02.Dialogue5.06",
		"Intro02.Dialogue5.07",
		"Intro02.Dialogue5.08",
		"Intro02.Dialogue5.09"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_6(from : ScriptingNode, from_slot : int, to : ScriptingNode, to_slot : int) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_5")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue6.01",
		"Intro02.Dialogue6.02"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_7() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_on_dialogue_7_finished")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue7.01",
		"Intro02.Dialogue7.02"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_8(anim : String) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_9")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue8.01"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_9() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_10")
	dialogue_inst.speaker = "hacker"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue9.01",
		"Intro02.Dialogue9.02",
		"Intro02.Dialogue9.03"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_10() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_on_dialogue_10_finished")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Intro02.Dialogue10.01",
		"Intro02.Dialogue10.02"
	]
	ui_canvas_layer.add_child(dialogue_inst)


# HINTS
func _hint_1() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_1_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_open_scripting_mode.png")
	hint_resource.content = "Intro02.Hint1.01"
	hint_panel.hints = [
		hint_resource
	]
	ui_canvas_layer.add_child(hint_panel)


func _hint_2() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_2_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_open_brain.png")
	hint_resource.content = "Intro02.Hint2.01."
	hint_panel.hints = [
		hint_resource
	]
	ui_canvas_layer.add_child(hint_panel)


func _hint_3() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_3_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_add_node.png")
	hint_resource.content = "Intro02.Hint3.01."
	hint_panel.hints = [
		hint_resource
	]
	ui_canvas_layer.add_child(hint_panel)


func _hint_4() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_4_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_connect_nodes.png")
	hint_resource.content = "Intro02.Hint4.01."
	hint_panel.hints = [
		hint_resource
	]
	ui_canvas_layer.add_child(hint_panel)


func _hint_5() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_5_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_save_brain.png")
	hint_resource.content = "Intro02.Hint5.01."
	hint_panel.hints = [
		hint_resource
	]
	ui_canvas_layer.add_child(hint_panel)


func _on_hint_1_closed() -> void:
	Globals.disable_scripting = false
	Globals.connect("scripting_toggled", self, "_dialogue_3", [], CONNECT_ONESHOT)


func _on_hint_2_closed() -> void:
	Globals.connect("open_scripting", self, "_dialogue_4", [], CONNECT_ONESHOT)


func _on_hint_3_closed() -> void:
	Globals.connect("scripting_node_added", self, "_dialogue_5", [], CONNECT_ONESHOT)


func _on_hint_4_closed() -> void:
	Globals.connect("scripting_node_connection", self, "_dialogue_6", [], CONNECT_ONESHOT)


func _on_hint_5_closed() -> void:
	Globals.disable_scripting = false
	Globals.connect("scripting_toggled", self, "_dialogue_7", [], CONNECT_ONESHOT)


# DIALOGUES
func _on_dialogue_1_finished() -> void:
	Globals.disable_inputs = false


func _on_dialogue_7_finished() -> void:
	BackgroundMusic.stream_paused = true
	shake_sfx.play()
	Globals.screenshake(0.6, 5.0)
	flash_animation_player.connect("animation_finished", self, "_dialogue_8", [], CONNECT_ONESHOT)
	Globals.connect("screenshake_finished", flash_animation_player, "play", ["Flash"], CONNECT_ONESHOT)


func _on_dialogue_10_finished() -> void:
	Globals.disable_inputs = false
	teleporter.is_active = true
	SaveManager.complete_level("Introduction")


func _on_TriggerZone_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		_dialogue_2()
		trigger_zone.queue_free()
