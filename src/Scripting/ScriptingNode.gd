extends GraphNode

var UPDATE_NODE := load("res://src/Scripting/Nodes/UpdateNode.tscn")
var MOVE_FORWARD_NODE := load("res://src/Scripting/Nodes/MoveForwardNode.tscn")

onready var ready = true;

onready var titleIcon := $TitleHBC/TitleIcon
onready var titleLabel := $TitleHBC/TitleLabel

var type : String

var PortList := {
	"NONE": {
		"type": 0,
		"color": Color.white
	},
	"RUN": {
		"type": 1,
		"color": Color.green
	}
}

var TypeList := {
	"UPDATE" : {
		"title": "Actualizar",
		"icon": load("res://assets/images/ui/scripting_icon_update.png"),
		"template": UPDATE_NODE,
		"slots": [
			[PortList.NONE, PortList.RUN]
		]
	},
	"MOVE_FORWARD" : {
		"title": "Avanzar",
		"icon": load("res://assets/images/ui/scripting_icon_update.png"),
		"template": MOVE_FORWARD_NODE,
		"slots": [
			[PortList.RUN, PortList.RUN],
			[PortList.NONE, PortList.NONE]
		]
	}
}

func _ready() -> void:
	_change_type(type)

func _change_type(type_name : String) -> void:
	if not ready or not TypeList.has(type_name):
		return
	
	# NODE TYPE
	var node = TypeList[type_name]
	titleLabel.text = node.title
	titleIcon.texture = node.icon
	
	# LOAD TEMPLATE
	var template_inst = node.template.instance()
	for child in template_inst.get_children():
		template_inst.remove_child(child)
		add_child(child)
	template_inst.queue_free()
	
	for i in range(node.slots.size()):
		var slot : Array = node.slots[i]
		set_slot(i + 1, false if slot[0].type == 0 else true, slot[0].type, slot[0].color, false if slot[1].type == 0 else true, slot[1].type, slot[1].color)
