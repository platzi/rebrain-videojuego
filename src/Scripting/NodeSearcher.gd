extends PopupPanel

signal node_selected

onready var node_list := $MarginContainer/VBoxContainer/NodeListSC/NodeListVBC

var NodeList = [
	["UPDATE", "Actualizar", "res://assets/images/ui/scripting_icon_update.png"],
	["ROTATE", "Girar", "res://assets/images/ui/scripting_icon_rotate.png"],
	["MOVE_FORWARD", "Avanzar", "res://assets/images/ui/scripting_icon_move_forward.png"],
	["TIMER", "Temporizador", "res://assets/images/ui/scripting_icon_timer.png"],
]

func _ready():
	for node in NodeList:
		var button := Button.new()
		button.set_meta("node_type", node[0])
		button.text = node[1]
		button.icon = load(node[2])
		button.connect("pressed", self, "_on_node_button_pressed", [node[0]])
		button.expand_icon = true
		node_list.add_child(button)


func _on_node_button_pressed(node_type : String) -> void:
	emit_signal("node_selected", node_type)
