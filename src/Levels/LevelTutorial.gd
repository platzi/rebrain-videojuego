extends Node

var dialogue_scene := load("res://src/Dialogue/Dialogue.tscn")

onready var ui_canvas_layer : CanvasLayer = $UI
onready var player : KinematicBody2D = $Game/YSort/Player
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var area_2d : Area2D = $TriggersZones/Area2D

var _enemy_clicked := false

func _ready():
	Globals.disable_scripting = true
	Globals.disable_inputs = true
	Globals.connect("scripting_toggled", self, "_dialogue_2", [], CONNECT_ONESHOT)
	Globals.connect("open_scripting", self, "_dialogue_3")
	Globals.connect("scripting_node_added", self, "_dialogue_4", [], CONNECT_ONESHOT)
	Globals.connect("scripting_node_connection", self, "_dialogue_5", [])
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")
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


func _dialogue_2() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.dialogues = [
		"Excelente, ahora estamos en el [b]Modo Scripting[/b], sientete como todo un hackerman",
		"Sabras que te encuentras en este modo por el efecto visual en tu GUI",
		"Mientras te encuentres en este modo, todas las entidades se detendrán",
		"Desde aquí podras entrar en el cerebro de las entidades haciendo click sobre ellas",
		"Vamos prueba hacer click sobre el [b]Gusano[/b]"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3(entity : Entity) -> void:
	var rand_dialogues = [
		"Casí lo consigues, pero debes te falto poco para hacer click en el [b]Gusano[/b]",
		"¿Acaso estas llamandolo [b]Gusano[/b]?",
		"Sabes muy bien que no puedo permitir eso",
		"¡Vamos tu puedes, yo creo en tí!"
	]
	if !_enemy_clicked:
		if entity.is_in_group("Enemy"):
			_enemy_clicked = true
			var dialogue_inst = dialogue_scene.instance()
			dialogue_inst.dialogues = [
				"¡Bienvenido a Re-Brain Scripting! aquí podrás podrás programar el cerebro de cualquier entidad",
				"Veras en la parte izquierda la entidad cuyo cerebro estas editando, además de unos botones",
				"[b]Guardar[/b]: Guardara los cambios en el cerebro y reiniciara a la entidad a su estado inicial",
				"[b]Restaurar[/b]: Regresara el cerebro a su forma inicial y descartara todos los cambios",
				"[b]Cancelar[/b]: Cancelara la edición del cerebro y no guardara los ultimos cambios",
				"En la parte derecha se encuentra el cerebro, el cual puedes programar utilizando nodos",
				"Puedes desplazarte por la gráfica presionando [b][BOTÓN MEDIO DEL RATÓN][/b] o tambien presionando [b][ESPACIO][/b] y [b][BOTÓN IZQUIERDO DEL RATÓN][/b]",
				"Notaras que ya he añadido unos cuantos nodos, estos estan bloqueados, puedes reconectarlos pero no eliminarlos ni moverlos",
				"Haremos que la entidad rote, para ello primero presion [b]BOTÓN DERECHO DEL RATÓN[/b] sobre la gráfica y selecciona el nodo Rotar"
			]
			ui_canvas_layer.add_child(dialogue_inst)
		else:
			var dialogue_inst = dialogue_scene.instance()
			dialogue_inst.dialogues = [
				rand_dialogues[randi() % rand_dialogues.size()]
			]
			Globals.emit_signal("scripting_abort")
			ui_canvas_layer.add_child(dialogue_inst)
	else:
		if !entity.is_in_group("Enemy"):
			var dialogue_inst = dialogue_scene.instance()
			dialogue_inst.dialogues = [
				rand_dialogues[randi() % rand_dialogues.size()]
			]
			Globals.emit_signal("scripting_abort")
			ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_4(node : ScriptingNode) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.dialogues = [
		"¡Bien hecho!",
		"Puedes arrastrar los nodos para moverlos por la gráfica, tambien puedes presionar [b][SUPR][/b] para eliminarlos",
		"Ahora lo siguiente es conectar el nodo para ejecutarlo",
		"Adelante, arrastra los puertos y unelos para conectarlos",
		"Recuerda solo puedes conectar puertos a otros del mismo color"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_5(from : ScriptingNode, from_port : int, to : ScriptingNode, to_port : int) -> void:
	if from.type == "ROTATE" or to.type == "ROTATE":
		Globals.disconnect("scripting_node_connection", self, "_dialogue_5")
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", self, "_dialogue_5_finished")
		dialogue_inst.dialogues = [
			"¡Lo has logrado!",
			"Ya solo falta [b]Guardar[/b] y salir del [b]Modo Scripting[/b], adelante, ¡veamos que tal funciona!"
		]
		ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_5_finished() -> void:
	Globals.connect("scripting_toggled", self, "_dialogue_6", [], CONNECT_ONESHOT)
	Globals.disable_scripting = false


func _dialogue_6() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_6_finished")
	dialogue_inst.dialogues = [
		"Perfecto, muy buen trabajo, con esto concluimos la clase de hoy, espero hayan aprendido...",
		"Un momento, ¿que fue eso?"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_6_finished() -> void:
	animation_player.connect("animation_finished", self, "_dialogue_7")
	Globals.connect("screenshake_finished", animation_player, "play", ["Flash"], CONNECT_ONESHOT)
	Globals.disable_scripting = false
	Globals.screenshake(2.0, 5.0)


func _dialogue_7(anim : String) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_7_finished")
	dialogue_inst.dialogues = [
		"Oh no, no puede ser...",
		"Creo que hemos sido hackeados...",
		"¿Donde estaran los demás alumnos? Espero se hayan logueado",
		"Vamos %s tenemos que irnos de aquí, ve hacía el portal yo ire después de tí" % [Globals.player_name]
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_7_finished() -> void:
	Globals.disable_inputs = false


func _on_Area2D_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		var rand_dialogues = [
			"Oye no vayas hacía alla, ¿acaso estas loco?",
			"No te acerques a esas cosas, son peligrosas",
			"Deja de estar jugando tenemos que irnos de aquí",
			"Esas cosas no son juguetes alejate de ahí",
		]
		Globals.disable_inputs = true
		var dialogue_inst = dialogue_scene.instance()
		dialogue_inst.connect("finished", self, "_dialogue_warning")
		dialogue_inst.dialogues = [
			rand_dialogues[randi() % rand_dialogues.size()],
		]
		ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_warning() -> void:
	Globals.disable_inputs = false
	player.move_towards(Vector2(528.0, 1056.0))
