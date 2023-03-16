extends Line2D


export(NodePath) var target_path
export var trail_offset := Vector2.ZERO
export var trail_length := 0

onready var target : Entity = get_node(target_path)

var point : Vector2


func _process(_delta : float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0.0
	point = target.global_position + trail_offset
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)
