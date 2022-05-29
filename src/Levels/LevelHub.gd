extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var ui_canvas_layer : CanvasLayer = $UI
onready var trigger_zone_1 : Area2D = $Game/TriggerZones/TriggerZone1
onready var trigger_zone_2 : Area2D = $Game/TriggerZones/TriggerZone2
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
			"Oye, ¡alto ahí!..."
		]
		ui_canvas_layer.add_child(dialogue_inst)

func _on_AnimationPlayer_animation_finished(anim : String) -> void:
	if anim == "intro_1":
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", animation_player, "play", ["intro_2"])
		dialogue_inst.dialogues = [
			"¿Formás parte del grupo BETA verdad?",
			"¡Que emoción! de verdad que no me lo creo que lo haya conseguido, porcierto ¿cual es tu nombre?",
			"Oh, así que te llamas %s, menúdo nombre, yo diría que tienes más cara de Jane..." % [Globals.player_name],
			"Pues, no hay que esperar más, ¡vamos sigueme, te espero en la puerta!",
		]
		ui_canvas_layer.add_child(dialogue_inst)
	elif anim == "intro_2" or anim == "intro_3":
		Globals.disable_inputs = false


func _on_TriggerZone2_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		Globals.disable_inputs = true
		trigger_zone_2.set_deferred("monitoring", false)
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", animation_player, "play", ["intro_3"])
		dialogue_inst.dialogues = [
			"¿Apoco no esta padrisimo el módelo 3D del edificio de Platzi?",
			"Una maravilla, todo parece tan real... no puedo creer que haya logrado vivir para ver esto",
			"Bueno, basta ya con la charla y entremos a clase, anda nos vemos alla"
		]
		ui_canvas_layer.add_child(dialogue_inst)
