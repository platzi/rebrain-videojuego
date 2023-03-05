tool


extends Node


const NODES = {
	"Eventos": [
		["UPDATE", "Actualizar", preload("res://assets/images/scripting/scripting_icon_update.png"), preload("res://src/Scripting/Nodes/UpdateNode.tscn")],
		["COLLISION", "Colisión", preload("res://assets/images/scripting/scripting_icon_collision.png"), preload("res://src/Scripting/Nodes/CollisionNode.tscn")],
		["TRIGGER", "Disparador", preload("res://assets/images/scripting/scripting_icon_trigger.png"), preload("res://src/Scripting/Nodes/TriggerNode.tscn")],
		["PRESSED", "Presionado", preload("res://assets/images/scripting/scripting_icon_pressed.png"), preload("res://src/Scripting/Nodes/PressedNode.tscn")],
		["RELEASED", "Soltado", preload("res://assets/images/scripting/scripting_icon_released.png"), preload("res://src/Scripting/Nodes/ReleasedNode.tscn")],
	],
	"Acciones": [
		["MOVE_FORWARD", "Avanzar", preload("res://assets/images/scripting/scripting_icon_move_forward.png"), preload("res://src/Scripting/Nodes/MoveForwardNode.tscn")],
		["ROTATE_LEFT", "Girar Izquierda", preload("res://assets/images/scripting/scripting_icon_rotate.png"), preload("res://src/Scripting/Nodes/RotateLeftNode.tscn")],
		["ROTATE_RIGHT", "Girar Derecha", preload("res://assets/images/scripting/scripting_icon_rotate.png"), preload("res://src/Scripting/Nodes/RotateRightNode.tscn")],
		["WAIT", "Esperar", preload("res://assets/images/scripting/scripting_icon_timer.png"), preload("res://src/Scripting/Nodes/WaitNode.tscn")],
		["SHOOT_TRIGGER", "Accionar disparador", preload("res://assets/images/scripting/scripting_icon_shoot_trigger.png"), preload("res://src/Scripting/Nodes/ShootTriggerNode.tscn")],
		["SHOOT", "Disparar", preload("res://assets/images/scripting/scripting_icon_shoot.png"), preload("res://src/Scripting/Nodes/ShootNode.tscn")],
		["OPEN", "Abrir", preload("res://assets/images/scripting/scripting_icon_open.png"), preload("res://src/Scripting/Nodes/OpenNode.tscn")],
		["CLOSE", "Cerrar", preload("res://assets/images/scripting/scripting_icon_close.png"), preload("res://src/Scripting/Nodes/CloseNode.tscn")],
	],
	"Lógica": [
		["IF", "Sí", preload("res://assets/images/scripting/scripting_icon_if.png"), preload("res://src/Scripting/Nodes/IfNode.tscn")],
		["AND", "Y", preload("res://assets/images/scripting/scripting_icon_and.png"), preload("res://src/Scripting/Nodes/AndNode.tscn")],
		["OR", "O", preload("res://assets/images/scripting/scripting_icon_or.png"), preload("res://src/Scripting/Nodes/OrNode.tscn")],
		["EQUAL", "Igual que", preload("res://assets/images/scripting/scripting_icon_equal.png"), preload("res://src/Scripting/Nodes/EqualNode.tscn")],
		["NOT_EQUAL", "No igual que", preload("res://assets/images/scripting/scripting_icon_not_equal.png"), preload("res://src/Scripting/Nodes/GreaterEqualNode.tscn")],
		["GREATER", "Mayor que", preload("res://assets/images/scripting/scripting_icon_greater.png"), preload("res://src/Scripting/Nodes/GreaterNode.tscn")],
		["GREATER_EQUAL", "Mayor o igual que", preload("res://assets/images/scripting/scripting_icon_greater_equal.png"), preload("res://src/Scripting/Nodes/GreaterEqualNode.tscn")],
		["LESS", "Menor que", preload("res://assets/images/scripting/scripting_icon_less.png"), preload("res://src/Scripting/Nodes/LessNode.tscn")],
		["LESS_EQUAL", "Menor o igual que", preload("res://assets/images/scripting/scripting_icon_less_equal.png"), preload("res://src/Scripting/Nodes/LessNode.tscn")],
		["COMPARE_ENTITY", "Comparar entidad", preload("res://assets/images/scripting/scripting_icon_compare.png"), preload("res://src/Scripting/Nodes/CompareEntityNode.tscn")],
		["COMPARE_STRING", "Comparar texto", preload("res://assets/images/scripting/scripting_icon_compare.png"), preload("res://src/Scripting/Nodes/CompareStringNode.tscn")],
		["PATH_AHEAD", "Camino adelante", preload("res://assets/images/scripting/scripting_icon_path_ahead.png"), preload("res://src/Scripting/Nodes/PathAheadNode.tscn")],
	],
	"Entradas": [
		["NUMBER", "Numero", preload("res://assets/images/scripting/scripting_icon_number.png"), preload("res://src/Scripting/Nodes/NumberNode.tscn")],
		["STRING", "Texto", preload("res://assets/images/scripting/scripting_icon_string.png"), preload("res://src/Scripting/Nodes/StringNode.tscn")],
		["BOOL", "Booleano", preload("res://assets/images/scripting/scripting_icon_bool.png"), preload("res://src/Scripting/Nodes/BoolNode.tscn")],
		["ENTITY", "Entidad", preload("res://assets/images/scripting/scripting_icon_entity.png"), preload("res://src/Scripting/Nodes/EntityNode.tscn")],
	],
	"Variables locales": [
		["POSITION", "Posición", preload("res://assets/images/scripting/scripting_icon_position.png"), preload("res://src/Scripting/Nodes/PositionNode.tscn")],
		["DIRECTION", "Dirección", preload("res://assets/images/scripting/scripting_icon_direction.png"), preload("res://src/Scripting/Nodes/DirectionNode.tscn")],
	]
}
