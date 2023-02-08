extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var ui_canvas_layer := $UI as CanvasLayer
onready var camera := $Camera
onready var player := $Entities/YSort/Player as KinematicBody2D
onready var key := $Entities/YSort/Key as Entity
onready var cage := $Entities/YSort/Cage as Entity
onready var teleporter := $Entities/YSort/Teleporter as Entity
onready var log_door := $Entities/YSort/LogDoor as Entity


func _ready() -> void:
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	player.animation_tree.set("parameters/Idle/blend_position", player.input_vector)
	get_tree().create_timer(0.5).connect("timeout", self, "_dialogue_1")
	cage.connect("unlocked", self, "_on_cage_unlocked")
	cage.connect("teleported", self, "_on_cage_teleported")


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_2")
	dialogue_inst.dialogues = [
		"Ahora que sabes como salvar a los alumnos continuemos la aventura"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	var dialogue_inst = dialogue_scene.instance()
	camera.target = log_door
	dialogue_inst.connect("finished", self, "_dialogue_3")
	dialogue_inst.dialogues = [
		"Oh... parece que el camino esta bloqueado"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3() -> void:
	var dialogue_inst = dialogue_scene.instance()
	camera.target = player
	dialogue_inst.connect("finished", self, "_dialogue_3_finished")
	dialogue_inst.dialogues = [
		"Parece que tendras que descubrir la manera de abrirte camino",
		"Recuerda que puedes abrir el Modo Scripting presionando [TAB]",
		"Prueba abrir los cerebros de las entidades para descubrir como pasar el obstaculo"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3_finished() -> void:
	Globals.disable_scripting = false
	Globals.disable_inputs = false


func _on_cage_unlocked() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", cage, "teleport")
	dialogue_inst.dialogues = [
		"¡Muchisimas gracias por rescatarme, te debo una!"
	]
	ui_canvas_layer.add_child(dialogue_inst)
	teleporter.position = cage.position
	teleporter.visible = true
	teleporter.activate()
	get_tree().paused = false


func _on_cage_teleported() -> void:
	camera.target = player
	Globals.disable_inputs = false
	Globals.disable_scripting = false
