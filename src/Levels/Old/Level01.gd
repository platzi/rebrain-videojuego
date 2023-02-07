extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var ui_canvas_layer : CanvasLayer = $UI
onready var player : KinematicBody2D = $Game/YSort/Player


func _ready():
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	player.animation_tree.set("parameters/Idle/blend_position", player.input_vector)
	_dialogue_1()


func _dialogue_1() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_1_finished")
	dialogue_inst.dialogues = [
		"!%s! ¿Te encuentras bien?" % [Globals.player_name],
		"Parece que nos han separado...",
		"¿Que como me estoy comunicando contigo? Bueno parece que es porqué no estamos muy lejos",
		"Tal parece que no solo han hackeado el [b]Platziverso[/b], si que tambien lo han convertido en un aburrido juego de puzzle",
		"Vas a necesitar ingeniartelas apartir de ahora para lograr salir... ",
		"Puede que incluso esta situación te sirva de aprendizaje",
		"Recuerda que para activar el [b]Modo Scripting[/b] necesitas presionar [b][TAB][/b]",
		"Bien pues no te quito más tu tiempo, ¡que tengas suerte!",
		"Oh y te recuerdo que estas en un mundo totalmente virtual donde absolutamente no corres nada de peligro",
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_1_finished() -> void:
	Globals.disable_scripting = false
	Globals.disable_inputs = false
