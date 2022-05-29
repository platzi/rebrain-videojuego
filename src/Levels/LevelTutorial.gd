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
		"Buen día tengan todos y sean bienvenidos al ¡[b]Platziverso[/b]!",
		"Un placer porfin conocerlos a los afortunados, muchas felicidades por formar parte del grupo BETA",
		"Muy bien, sin más preambulos, comenzamos con el curso básico de [b]RE-BRAIN[/b] o mejor conocido como...",
		"Reestructuración de Entidades de Bajos Recursos Altamente Inestables Nomadas",
		"Para comenzar...",
		"¿%s verdad? ¿Podrías ayudame con la demostración?" % [Globals.player_name],
		"Porfavor abre el [b]Scripting Tool[/b] pulsando [b][TAB][/b]"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_1_finished() -> void:
	Globals.disable_scripting = false
