tool

extends PopupPanel

signal node_selected

onready var node_list_vbc := $VBoxContainer/NodeListSC/NodeListVBC

var node_groups := {
	"Eventos": [
		["UPDATE", "Actualizar", preload("res://assets/images/scripting/scripting_icon_update.png")],
		["COLLISION", "Colisión", preload("res://assets/images/scripting/scripting_icon_collision.png")],
		["TRIGGER", "Disparador", preload("res://assets/images/scripting/scripting_icon_trigger.png")],
		["PRESSED", "Presionado", preload("res://assets/images/scripting/scripting_icon_pressed.png")],
		["RELEASED", "Soltado", preload("res://assets/images/scripting/scripting_icon_released.png")],
	],
	"Acciones": [
		["MOVE_FORWARD", "Avanzar", preload("res://assets/images/scripting/scripting_icon_move_forward.png")],
		["ROTATE_LEFT", "Girar Izquierda", preload("res://assets/images/scripting/scripting_icon_rotate.png")],
		["ROTATE_RIGHT", "Girar Derecha", preload("res://assets/images/scripting/scripting_icon_rotate.png")],
		["TIMER", "Temporizador", preload("res://assets/images/scripting/scripting_icon_timer.png")],
		["SHOOT_TRIGGER", "Accionar disparador", preload("res://assets/images/scripting/scripting_icon_shoot_trigger.png")],
		["SHOOT", "Disparar", preload("res://assets/images/scripting/scripting_icon_shoot.png")],
		["OPEN", "Abrir", preload("res://assets/images/scripting/scripting_icon_open.png")],
		["CLOSE", "Cerrar", preload("res://assets/images/scripting/scripting_icon_close.png")],
	],
	"Lógica": [
		["IF", "Sí", preload("res://assets/images/scripting/scripting_icon_if.png")],
		["AND", "Y", preload("res://assets/images/scripting/scripting_icon_and.png")],
		["OR", "O", preload("res://assets/images/scripting/scripting_icon_or.png")],
		["EQUAL", "Igual que", preload("res://assets/images/scripting/scripting_icon_equal.png")],
		["NOT_EQUAL", "No igual que", preload("res://assets/images/scripting/scripting_icon_not_equal.png")],
		["GREATER", "Mayor que", preload("res://assets/images/scripting/scripting_icon_greater.png")],
		["GREATER_EQUAL", "Mayor o igual que", preload("res://assets/images/scripting/scripting_icon_greater_equal.png")],
		["LESS", "Menor que", preload("res://assets/images/scripting/scripting_icon_less.png")],
		["LESS_EQUAL", "Menor o igual que", preload("res://assets/images/scripting/scripting_icon_less.png")],
		["COMPARE_ENTITY", "Comparar entidad", preload("res://assets/images/scripting/scripting_icon_compare.png")],
		["COMPARE_STRING", "Comparar texto", preload("res://assets/images/scripting/scripting_icon_compare.png")],
	],
	"Entradas": [
		["NUMBER", "Numero", preload("res://assets/images/scripting/scripting_icon_number.png")],
		["STRING", "Texto", preload("res://assets/images/scripting/scripting_icon_string.png")],
		["BOOL", "Booleano", preload("res://assets/images/scripting/scripting_icon_bool.png")],
		["ENTITY", "Entidad", preload("res://assets/images/scripting/scripting_icon_entity.png")],
	],
	"Variables locales": [
		["POSITION", "Posición", preload("res://assets/images/scripting/scripting_icon_position.png")],
		["DIRECTION", "Dirección", preload("res://assets/images/scripting/scripting_icon_direction.png")],
	]
}

var blacklist := [] setget _set_blacklist

func _ready():
	_create_buttons()


func _input(event : InputEvent) -> void:
	if Globals.DEBUG and event is InputEventKey and event.pressed and event.scancode == KEY_U:
		blacklist = []
		_create_buttons()


func _clear_buttons() -> void:
	for child in node_list_vbc.get_children():
		child.queue_free()


func _create_buttons() -> void:
	_clear_buttons()
	for group in node_groups:
		var added_count := 0
		var group_button := Label.new()
		group_button.align = Label.ALIGN_LEFT
		group_button.text = group
		node_list_vbc.add_child(group_button)
		for node in node_groups[group]:
			if !blacklist.has(node[0]):
				var button := Button.new()
				button.align = Button.ALIGN_LEFT
				button.text = node[1]
				if node[2]:
					button.icon = node[2]
				button.connect("pressed", self, "_on_node_button_pressed", [node[0]])
				button.expand_icon = true
				button.focus_mode = Control.FOCUS_NONE
				node_list_vbc.add_child(button)
				added_count += 1
		if added_count == 0:
			group_button.visible = false


func _on_node_button_pressed(node_type : String) -> void:
	emit_signal("node_selected", node_type)


func _set_blacklist(new_value : Array) -> void:
	blacklist = new_value
	_create_buttons()

