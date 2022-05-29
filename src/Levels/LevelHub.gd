extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var trigger_zone_1 : Area2D = $Game/TriggerZones/TriggerZone1
onready var trigger_zone_2 : Area2D = $Game/TriggerZones/TriggerZone2
onready var ui_canvas_layer : CanvasLayer = $UI
onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	trigger_zone_1.connect("body_entered", self, "_on_TriggerZone1_body_entered")
	trigger_zone_2.connect("body_entered", self, "_on_TriggerZone2_body_entered")
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func _on_TriggerZone1_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		Globals.disable_inputs = true
		trigger_zone_1.set_deferred("monitoring", false)
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", animation_player, "play", ["intro_1"])
		dialogue_inst.dialogues = [
			"Oye espera un momento..."
		]
		ui_canvas_layer.add_child(dialogue_inst)

func _on_AnimationPlayer_animation_finished(anim : String) -> void:
	if anim == "intro_1":
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", animation_player, "play", ["intro_2"])
		dialogue_inst.dialogues = [
			"¿Eres nuevo por aquí verdad? ¿Cual es tu nombre?",
			"Oh, con que Arnoldo Chávez, pues ¡bienvenido al [b]Platziverso[/b]!",
			"Vamos sigueme, la clase esta por comenzar, el profesor ya debe estar online"
		]
		ui_canvas_layer.add_child(dialogue_inst)
	elif anim == "intro_2":
		Globals.disable_inputs = false
#		var dialogue_inst = dialogue_scene.instance()
#		dialogue_inst.dialogues = [
#			"Oh, pero si eres [b]Arnoldo Chávez[/b], te estabamos esperando",
#			"Adelante sigueme"
#		]
#		ui_canvas_layer.add_child(dialogue_inst)


func _on_TriggerZone2_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		Globals.disable_inputs = true
		trigger_zone_2.set_deferred("monitoring", false)
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", animation_player, "play", ["intro_3"])
		dialogue_inst.dialogues = [
			"¿Apoco no esta padrisimo el módelo 3D del edificio de Platzi?",
			"Una maravilla, parece tan real...",
			"Bueno, pero dejemonos de charla y vayamos a clase, anda nos vemos alla"
		]
		ui_canvas_layer.add_child(dialogue_inst)
