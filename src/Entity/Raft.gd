tool


extends Entity


onready var riders_area := $RidersArea as Area2D


var old_position : Vector2


func _physics_process(delta : float) -> void:
	for rider in riders_area.get_overlapping_bodies():
		if rider != self and not rider.is_in_group("Projectile") and rider is Entity or rider.is_in_group("Player"):
			rider.position += position - old_position
	old_position = position
