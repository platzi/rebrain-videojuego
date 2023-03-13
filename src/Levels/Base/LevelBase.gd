extends Node


var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")
var hint_scene := load("res://src/HintPanel/HintPanel.tscn")


onready var ui_canvas_layer := $UI as CanvasLayer
onready var intro_events := $IntroEvents
onready var saved_events := $SavedEvents
onready var completed_events := $CompletedEvents
onready var camera := $Camera
onready var teleporter := $Entities/YSort/Teleporter
onready var player := $Entities/YSort/Player
onready var cage := $Entities/YSort/Cage as Entity


func _ready() -> void:
	Globals.connect("node_info_pressed", self, "_on_node_info_pressed")
	intro_events.execute()
	if cage:
		cage.connect("unlocked", self, "_on_cage_unlocked")
		cage.connect("teleported", self, "_on_cage_teleported")


func create_dialogue(speaker : String, dialogues : PoolStringArray) -> Dialogue:
	var dialogue_inst : Dialogue = dialogue_scene.instance()
	dialogue_inst.speaker = speaker
	dialogue_inst.dialogues = dialogues
	ui_canvas_layer.add_child(dialogue_inst)
	return dialogue_inst


func create_hint(title : String, hints : Array) -> HintPanel:
	var hint_inst : HintPanel = hint_scene.instance()
	hint_inst.title = title
	hint_inst.hints = hints.duplicate(true)
	ui_canvas_layer.add_child(hint_inst)
	return hint_inst


func _on_cage_unlocked() -> void:
	saved_events.connect("finished", self, "_on_saved_events_finished", [], CONNECT_ONESHOT)
	saved_events.execute()
	if teleporter:
		teleporter.position = cage.position
		teleporter.visible = true
		teleporter.activate()
	get_tree().paused = false


func _on_cage_teleported() -> void:
	Globals.disable_inputs = false
	Globals.disable_scripting = false
	completed_events.execute()
	camera.target = player


func _on_saved_events_finished() -> void:
	if cage:
		Globals.disable_inputs = true
		Globals.disable_scripting = true
		cage.teleport()


func _on_node_info_pressed(hints) -> void:
	Globals.disable_inputs = true
	Globals.disable_scripting = true
	for hint in hints:
		hint.content = tr(hint.content)
	yield(create_hint("Nodos", hints), "closed")
	Globals.disable_inputs = false
	Globals.disable_scripting = false
