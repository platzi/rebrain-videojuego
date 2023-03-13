tool


extends Node


var NODES = {
	"Eventos": [
		["UPDATE", tr("NODE.UPDATE.TITLE"), preload("res://assets/images/scripting/scripting_icon_update.png"), preload("res://src/Scripting/Nodes/UpdateNode.tscn")],
		["COLLISION", tr("NODE.COLLISION.TITLE"), preload("res://assets/images/scripting/scripting_icon_collision.png"), preload("res://src/Scripting/Nodes/CollisionNode.tscn")],
		["TRIGGER", tr("NODE.TRIGGER.TITLE"), preload("res://assets/images/scripting/scripting_icon_trigger.png"), preload("res://src/Scripting/Nodes/TriggerNode.tscn")],
		["PRESSED", tr("NODE.PRESSED.TITLE"), preload("res://assets/images/scripting/scripting_icon_pressed.png"), preload("res://src/Scripting/Nodes/PressedNode.tscn")],
		["RELEASED", tr("NODE.RELEASED.TITLE"), preload("res://assets/images/scripting/scripting_icon_released.png"), preload("res://src/Scripting/Nodes/ReleasedNode.tscn")],
	],
	"Acciones": [
		["MOVE_FORWARD", tr("NODE.MOVE_FORWARD.TITLE"), preload("res://assets/images/scripting/scripting_icon_move_forward.png"), preload("res://src/Scripting/Nodes/MoveForwardNode.tscn")],
		["MOVE_RIGHT", tr("NODE.MOVE_RIGHT.TITLE"), preload("res://assets/images/scripting/scripting_icon_move_right.png"), preload("res://src/Scripting/Nodes/MoveRightNode.tscn")],
		["MOVE_DOWN", tr("NODE.MOVE_DOWN.TITLE"), preload("res://assets/images/scripting/scripting_icon_move_down.png"), preload("res://src/Scripting/Nodes/MoveDownNode.tscn")],
		["MOVE_LEFT", tr("NODE.MOVE_LEFT.TITLE"), preload("res://assets/images/scripting/scripting_icon_move_left.png"), preload("res://src/Scripting/Nodes/MoveLeftNode.tscn")],
		["MOVE_UP", tr("NODE.MOVE_UP.TITLE"), preload("res://assets/images/scripting/scripting_icon_move_up.png"), preload("res://src/Scripting/Nodes/MoveUpNode.tscn")],
		["ROTATE_LEFT", tr("NODE.ROTATE_LEFT.TITLE"), preload("res://assets/images/scripting/scripting_icon_rotate_left.png"), preload("res://src/Scripting/Nodes/RotateLeftNode.tscn")],
		["ROTATE_RIGHT", tr("NODE.ROTATE_RIGHT.TITLE"), preload("res://assets/images/scripting/scripting_icon_rotate_right.png"), preload("res://src/Scripting/Nodes/RotateRightNode.tscn")],
		["WAIT", tr("NODE.WAIT.TITLE"), preload("res://assets/images/scripting/scripting_icon_timer.png"), preload("res://src/Scripting/Nodes/WaitNode.tscn")],
		["SHOOT_TRIGGER", tr("NODE.SHOOT_TRIGGER.TITLE"), preload("res://assets/images/scripting/scripting_icon_shoot_trigger.png"), preload("res://src/Scripting/Nodes/ShootTriggerNode.tscn")],
		["SHOOT", tr("NODE.SHOOT.TITLE"), preload("res://assets/images/scripting/scripting_icon_shoot.png"), preload("res://src/Scripting/Nodes/ShootNode.tscn")],
		["OPEN", tr("NODE.OPEN.TITLE"), preload("res://assets/images/scripting/scripting_icon_open.png"), preload("res://src/Scripting/Nodes/OpenNode.tscn")],
		["CLOSE", tr("NODE.CLOSE.TITLE"), preload("res://assets/images/scripting/scripting_icon_close.png"), preload("res://src/Scripting/Nodes/CloseNode.tscn")],
	],
	"Lógica": [
		["IF", tr("NODE.IF.TITLE"), preload("res://assets/images/scripting/scripting_icon_if.png"), preload("res://src/Scripting/Nodes/IfNode.tscn")],
		["AND", tr("NODE.AND.TITLE"), preload("res://assets/images/scripting/scripting_icon_and.png"), preload("res://src/Scripting/Nodes/AndNode.tscn")],
		["OR", tr("NODE.OR.TITLE"), preload("res://assets/images/scripting/scripting_icon_or.png"), preload("res://src/Scripting/Nodes/OrNode.tscn")],
		["EQUAL", tr("NODE.EQUAL.TITLE"), preload("res://assets/images/scripting/scripting_icon_equal.png"), preload("res://src/Scripting/Nodes/EqualNode.tscn")],
		["NOT_EQUAL", tr("NODE.NOT_EQUAL.TITLE"), preload("res://assets/images/scripting/scripting_icon_not_equal.png"), preload("res://src/Scripting/Nodes/NotEqualNode.tscn")],
		["GREATER", tr("NODE.GREATER.TITLE"), preload("res://assets/images/scripting/scripting_icon_greater.png"), preload("res://src/Scripting/Nodes/GreaterNode.tscn")],
		["GREATER_EQUAL", tr("NODE.GREATER_EQUAL.TITLE"), preload("res://assets/images/scripting/scripting_icon_greater_equal.png"), preload("res://src/Scripting/Nodes/GreaterEqualNode.tscn")],
		["LESS", tr("NODE.LESS.TITLE"), preload("res://assets/images/scripting/scripting_icon_less.png"), preload("res://src/Scripting/Nodes/LessNode.tscn")],
		["LESS_EQUAL", tr("NODE.LESS_EQUAL.TITLE"), preload("res://assets/images/scripting/scripting_icon_less_equal.png"), preload("res://src/Scripting/Nodes/LessEqualNode.tscn")],
		["COMPARE_ENTITY", tr("NODE.COMPARE_ENTITY.TITLE"), preload("res://assets/images/scripting/scripting_icon_compare.png"), preload("res://src/Scripting/Nodes/CompareEntityNode.tscn")],
		["COMPARE_STRING", tr("NODE.COMPARE_STRING.TITLE"), preload("res://assets/images/scripting/scripting_icon_compare.png"), preload("res://src/Scripting/Nodes/CompareStringNode.tscn")],
		["REPEAT", tr("NODE.REPEAT.TITLE"), preload("res://assets/images/scripting/scripting_icon_repeat.png"), preload("res://src/Scripting/Nodes/RepeatNode.tscn")],
		["PATH_AHEAD", tr("NODE.PATH_AHEAD.TITLE"), preload("res://assets/images/scripting/scripting_icon_path_ahead.png"), preload("res://src/Scripting/Nodes/PathAheadNode.tscn")],
		["PATH_BACK", tr("NODE.PATH_BACK.TITLE"), preload("res://assets/images/scripting/scripting_icon_path_ahead.png"), preload("res://src/Scripting/Nodes/PathBackNode.tscn")],
		["PATH_LEFT", tr("NODE.PATH_LEFT.TITLE"), preload("res://assets/images/scripting/scripting_icon_path_ahead.png"), preload("res://src/Scripting/Nodes/PathLeftNode.tscn")],
		["PATH_RIGHT", tr("NODE.PATH_RIGHT.TITLE"), preload("res://assets/images/scripting/scripting_icon_path_ahead.png"), preload("res://src/Scripting/Nodes/PathRightNode.tscn")],
		["PASSENGERS", tr("NODE.PASSENGERS.TITLE"), preload("res://assets/images/scripting/scripting_icon_passengers.png"), preload("res://src/Scripting/Nodes/PassengersNode.tscn")],
	],
	"Literales": [
		["NUMBER", tr("NODE.NUMBER.TITLE"), preload("res://assets/images/scripting/scripting_icon_number.png"), preload("res://src/Scripting/Nodes/NumberNode.tscn")],
		["STRING", tr("NODE.STRING.TITLE"), preload("res://assets/images/scripting/scripting_icon_string.png"), preload("res://src/Scripting/Nodes/StringNode.tscn")],
		["BOOL", tr("NODE.BOOL.TITLE"), preload("res://assets/images/scripting/scripting_icon_bool.png"), preload("res://src/Scripting/Nodes/BoolNode.tscn")],
		["ENTITY", tr("NODE.ENTITY.TITLE"), preload("res://assets/images/scripting/scripting_icon_entity.png"), preload("res://src/Scripting/Nodes/EntityNode.tscn")],
	],
	"Valores": [
		["POSITION", tr("NODE.POSITION.TITLE"), preload("res://assets/images/scripting/scripting_icon_position.png"), preload("res://src/Scripting/Nodes/PositionNode.tscn")],
		["DIRECTION", tr("NODE.DIRECTION.TITLE"), preload("res://assets/images/scripting/scripting_icon_direction.png"), preload("res://src/Scripting/Nodes/DirectionNode.tscn")],
	]
}
