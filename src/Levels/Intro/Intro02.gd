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
		"Excelente, ya que porfin estamos todos aquí, vamos a comenzar nuestra primer clase en el Platziverso",
		"Antes de comenzar les doy la bienvenida a todos a clase Programando utilizando Visual Scripting",
		"Utilizaremos el sistema ReBrain, el cual fue creado espeficamente para el Platziverso",
		"Este sistema les permitira editar el cerebro de las entidades dentro del mundo",
		"Vamos a comenzar haciendo una pequeña demostración donde veremos lo más básico",
		"%s porfavor pasa hacía adelante, me ayudaras a demostrar como funciona ReBrain" % Globals.player_name
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_2() -> void:
	Globals.disable_inputs = true
	player.input_vector = Vector2.UP
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_1")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Vamos a comenzar activando el modo scripting, para ello presiona [img=36]assets/images/keyboard/tab.png[/img]",
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_3() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_2")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"¡Muy bien!, ahora mismo estas en el modo scripting, te habrás dado cuenta porque el fondo ha cambiado",
		"Lo primero que debés saber es que las entidades con las que puedes interactuar estan resaltadas",
		"Tambien como notaras hay entidades resaltadas en rojo, esas no se pueden modificar",
		"Adelante prueba hacer click al muñeco de pruebas que se encuentra a mi lado"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_4(entity : Entity) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_3")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"¡Perfecto!, ahora mismo te encuentras en el cerebro de la entidad, en este caso del muñeco de pruebas",
		"En la parte izquierda podrás ver la entidad que se esta programando y en la parte derecha encontraras la gráfica donde podrás jugar con los nodos para programar a la entidad",
		"Probemos agregar un nodo de Girar, haz click derecho sobre la gráfica de la parte derecha"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_5(node : ScriptingNode) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_4")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"¡Estas haciendolo excelente!, lo siguiente que tenemos que hacer es conectar los nodos para que estos funcionen",
		"Veras que el nodo que se añadio tiene un [img]assets/images/scripting/node_port_green.png[/img] del lado izquierdo y derecho",
		"Se conoce como entrada y salida, cada nodo tiene diferentes tipos de entradas y salidas",
		"Y estas van conectadas con respecto a su tipo, gráficamente mostrado por un color",
		"Solo puedes hacer conexiones entre salida y entrada, respetando su tipo",
		"El nodo de Girar tiene dos conexiones de Ejecución, tanto en la entrada como la salida, mostrado con el color verde",
		"Esta conexión ejecutara el nodo una vez activada la entrada, y la salida se activara una vez terminada la ejecución del nodo",
		"Bueno, mucha charla poca acción, vamos a conectar el nodo de Girar con el nodo de Esperar",
		"Para hacerlo presiona y arrastra el [img]assets/images/scripting/node_port_green.png[/img] para hacer una conexión"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_6(from : ScriptingNode, from_slot : int, to : ScriptingNode, to_slot : int) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_hint_5")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"¡Excelente trabajo! ya has aprendido a conectar nodos entre si, aún queda más por aprender pero por ahora vamos a Guardar y salir del modo scripting",
		"Para salir del modo scripting hay que presionar nuevamente [img=36]assets/images/keyboard/tab.png[/img] en la pantalla de scripting"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_7() -> void:
	Globals.disable_scripting = true
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_on_dialogue_7_finished")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"Que bien lo has hecho %s, muchas gracias por tu ayuda" % Globals.player_name,
		"Ahora que conocen un poco sobre el sistema ReBrain vamos a continuar con..."
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_8(anim : String) -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_9")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"¿Donde ha ido todo el mundo?"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_9() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_dialogue_10")
	dialogue_inst.speaker = "hacker"
	dialogue_inst.dialogues = [
		"Hola Platziverso, parece que tienen una pequeña falla en la seguridad, ha sido muy fácil entrar en su sistema",
		"Si se preguntan donde estan sus preciados alumnos, bueno, los he mandado por diferentes niveles del metaverso",
		"Vamos a divertirnos un poco, ¡nos veremos pronto!"
	]
	ui_canvas_layer.add_child(dialogue_inst)


func _dialogue_10() -> void:
	var dialogue_inst = dialogue_scene.instance()
	dialogue_inst.connect("finished", self, "_on_dialogue_10_finished")
	dialogue_inst.speaker = "Profesor"
	dialogue_inst.dialogues = [
		"No puedo creerlo, hemos sido hackeados",
		"%s vamos salgamos de aquí, los profesores nos encargaremos de esto" % Globals.player_name
	]
	ui_canvas_layer.add_child(dialogue_inst)


# HINTS
func _hint_1() -> void:
	var hint_panel : HintPanel = hint_panel_scene.instance()
	hint_panel.connect("closed", self, "_on_hint_1_closed")
	hint_panel.title = "Guía Básica"
	var hint_resource := HintResource.new()
	hint_resource.image = preload("res://assets/images/hints/hint_open_scripting_mode.png")
	hint_resource.content = "[b][color=#3700a7]Modo scripting[/color][/b]\nPresiona [img=36]assets/images/keyboard/tab.png[/img] para activar el [color=#3700a7]Modo scripting[/color]. En este modo se resaltarán las entidades con las cuales puedes interactuar."
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
	hint_resource.content = "[b][color=#3700a7]ReBrain[/color][/b]\nAl estar en el [color=#3700a7]Modo Scripting[/color] y hacer click sobre una entidad se abrira el cerebro de esta, desde aquí podrás modificar su comportamiento utilizando distintos nodos."
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
	hint_resource.content = "[b][color=#3700a7]Agregar nodo[/color][/b]\nCon click derecho en la gráfica se abrira el buscador de nodos, desde ahí puedes seleccionar cual nodo agregar."
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
	hint_resource.content = "[b][color=#3700a7]Conectar nodos[/color][/b]\nArrastra con click izquierdo los círculos de las entradas o salidas para crear una conexión entre nodos."
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
	hint_resource.content = "[b][color=#3700a7]Guardar[/color][/b]\nGuarda los cambios que se hayan realizado al cerebro de la entidad y hace que esta se reinicie a su posición inicial."
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
