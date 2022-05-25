extends GraphNode

signal run_finished

const UPDATE_NODE := preload("res://src/Scripting/Nodes/UpdateNode.tscn")
const ROTATE_NODE := preload("res://src/Scripting/Nodes/RotateNode.tscn")
const MOVE_FORWARD_NODE := preload("res://src/Scripting/Nodes/MoveForwardNode.tscn")
const TIMER_NODE := preload("res://src/Scripting/Nodes/TimerNode.tscn")

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
		"method": "_update",
		"slots": [
			[PortList.NONE, PortList.RUN]
		]
	},
	"ROTATE" : {
		"title": "Girar",
		"icon": load("res://assets/images/ui/scripting_icon_rotate.png"),
		"template": ROTATE_NODE,
		"method": "_rotate",
		"slots": [
			[PortList.RUN, PortList.RUN]
		]
	},
	"MOVE_FORWARD" : {
		"title": "Avanzar",
		"icon": load("res://assets/images/ui/scripting_icon_move_forward.png"),
		"template": MOVE_FORWARD_NODE,
		"method": "_move_forward",
		"slots": [
			[PortList.RUN, PortList.RUN]
		]
	},
	"TIMER" : {
		"title": "Temporizador",
		"icon": load("res://assets/images/ui/scripting_icon_timer.png"),
		"template": TIMER_NODE,
		"method": "_timer",
		"slots": [
			[PortList.RUN, PortList.RUN]
		]
	}
}

var type : String
var timer := Timer.new()

onready var ready = true
onready var title_icon := $TitleMC/TitleMC/TitleHBC/TitleIcon
onready var title_label := $TitleMC/TitleMC/TitleHBC/TitleLabel

func _ready() -> void:
	# Connections
	timer.connect("timeout", self, "emit_signal", ["run_finished"])
	
	_change_type(type)
	add_child(timer)


func _change_type(type_name : String) -> void:
	if not ready or not TypeList.has(type_name):
		return
	
	# Get node
	var node = TypeList[type_name]
	title_label.text = node.title
	title_icon.texture = node.icon
	
	# Load template
	var template_inst = node.template.instance()
	for child in template_inst.get_children():
		template_inst.remove_child(child)
		add_child(child)
	template_inst.queue_free()
	
	# Prepare slots
	for i in range(node.slots.size()):
		var slot : Array = node.slots[i]
		set_slot(i + 1, false if slot[0].type == 0 else true, slot[0].type, slot[0].color, false if slot[1].type == 0 else true, slot[1].type, slot[1].color)


func run() -> GraphNode:
	if not ready or not TypeList.has(type):
		return null
	
	# Get node and execute his method
	var node = TypeList[type]
	call(node.method)
	return self


func _update() -> void:
	print("UPDATE")
	emit_signal("run_finished")


func _rotate() -> void:
	print("ROTATE")
	emit_signal("run_finished")


func _move_forward() -> void:
	print("MOVE FORWARD")
	var timerSB : SpinBox = find_node("TimerSB", true, false)
	if timerSB == null:
		return
	timer.start(timerSB.value)


func _timer() -> void:
	print("TIMER")
	var timerSB : SpinBox = find_node("TimerSB", true, false)
	if timerSB == null:
		return
	timer.start(timerSB.value)
