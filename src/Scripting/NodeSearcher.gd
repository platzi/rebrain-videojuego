tool

extends PopupPanel

signal node_selected

onready var node_list_vbc := $VBoxContainer/NodeListSC/NodeListVBC

var node_groups := {
	"Eventos": [
		["UPDATE", "Actualizar", "res://assets/images/ui/scripting_icon_update.png"],
		["COLLISION", "Colisión", "res://assets/images/ui/scripting_icon_collision.png"],
		["TRIGGER", "Disparador", "res://assets/images/ui/scripting_icon_trigger.png"],
	],
	"Acciones": [
		["ROTATE", "Girar", "res://assets/images/ui/scripting_icon_rotate.png"],
		["MOVE_FORWARD", "Avanzar", "res://assets/images/ui/scripting_icon_move_forward.png"],
		["TIMER", "Temporizador", "res://assets/images/ui/scripting_icon_timer.png"],
		["MESSAGE", "Mensaje", "res://assets/images/ui/scripting_icon_message.png"],
		["SHOOT_TRIGGER", "Accionar disparador", "res://assets/images/ui/scripting_icon_shoot_trigger.png"],
		["ACTIVATE", "Activar", "res://assets/images/ui/scripting_icon_activate.png"],
		["SHOOT", "Disparar", "res://assets/images/ui/scripting_icon_shoot.png"],
		["EXPLODE", "Explotar", "res://assets/images/ui/scripting_icon_explode.png"],
	],
	"Lógica": [
		["COMPARE_ENTITY", "Comparar entidad", "res://assets/images/ui/scripting_icon_compare.png"],
		["COMPARE_STRING", "Comparar texto", "res://assets/images/ui/scripting_icon_compare.png"],
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
		var group_button := Label.new()
		group_button.align = Label.ALIGN_LEFT
		group_button.text = group
		node_list_vbc.add_child(group_button)
		for node in node_groups[group]:
			var button := Button.new()
			button.align = Button.ALIGN_LEFT
			button.text = node[1]
			button.icon = load(node[2])
			button.connect("pressed", self, "_on_node_button_pressed", [node[0]])
			button.expand_icon = true
			button.focus_mode = Control.FOCUS_NONE
			if blacklist.has(node[0]):
				button.disabled = true
			node_list_vbc.add_child(button)


func _on_node_button_pressed(node_type : String) -> void:
	emit_signal("node_selected", node_type)


func _set_blacklist(new_value : Array) -> void:
	blacklist = new_value
	_create_buttons()

