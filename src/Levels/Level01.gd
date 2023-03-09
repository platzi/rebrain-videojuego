extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var ui_canvas_layer := $UI as CanvasLayer
onready var camera := $Camera
onready var player := $Entities/YSort/Player as KinematicBody2D
onready var key := $Entities/YSort/Key as Entity
onready var cage := $Entities/YSort/Cage as Entity
onready var teleporter := $Entities/YSort/Teleporter as Entity


func _ready() -> void:
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.direction = 270.0
	get_tree().create_timer(0.5).connect("timeout", self, "_dialogue_1")
	cage.connect("unlocked", self, "_on_cage_unlocked")
	cage.connect("teleported", self, "_on_cage_teleported")


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_2")
	dialogue_inst.dialogues = [
		"Tranquilo no te asustes, seguimos en el Platziverso, este solo es un mundo tematico",
		"Tampoco tienes mucho que temer, recuerda que todo lo que aquí sucede no te afecta en el mundo real... o por lo menos eso creemos",
		"Bien, vamos a aprovechar esta tranquilidad para enseñarte lo básico",
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	var dialogue_inst = dialogue_scene.instance()
	camera.target = key
	dialogue_inst.connect("finished", self, "_dialogue_3")
	dialogue_inst.dialogues = [
		"Este pequeño objeto reluciente es una llave, ¿sabes para que funcionan las llaves cierto?",
		"¿No? ¿Enserio?...",
		"Vaya, si que eres nuevo en esto, bueno esta llave sirve para..."
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3() -> void:
	var dialogue_inst = dialogue_scene.instance()
	camera.target = cage
	dialogue_inst.connect("finished", self, "_dialogue_4")
	dialogue_inst.dialogues = [
		"Abrir esta celda y rescatar al estudiante que se encuentra prisionero",
		"Solo basta con tocar la llave y la celda se abrira como por arte de mágia, aunque realmente no es mágia si no multiples líneas de código...",
		"Super sencillo, ¿verdad?"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_4() -> void:
	var dialogue_inst = dialogue_scene.instance()
	camera.target = player
	dialogue_inst.connect("finished", self, "_dialogue_4_finished")
	dialogue_inst.dialogues = [
		"Vamos, prueba a ir a tomar la llave, solo muevete hacía ella",
		"Te recuerdo que puedes moverte con las teclas [WASD], así es ¡como todo videojuego!"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_4_finished() -> void:
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
