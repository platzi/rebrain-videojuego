tool

extends PopupPanel

signal node_selected

onready var node_list_vbc := $VBoxContainer/NodeListSC/NodeListVBC

var node_list := [
	["UPDATE", "Actualizar", "res://assets/images/ui/scripting_icon_update.png"],
	["ROTATE", "Girar", "res://assets/images/ui/scripting_icon_rotate.png"],
	["MOVE_FORWARD", "Avanzar", "res://assets/images/ui/scripting_icon_move_forward.png"],
	["TIMER", "Temporizador", "res://assets/images/ui/scripting_icon_timer.png"],
	["SHOOT", "Disparar", "res://assets/images/ui/scripting_icon_shoot.png"],
	["MESSAGE", "Mensaje", "res://assets/images/ui/scripting_icon_message.png"],
]

var blacklist := [
	"UPDATE"
]

func _ready():
	for node in node_list:
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
