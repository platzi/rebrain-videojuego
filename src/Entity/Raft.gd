tool


extends Entity


onready var riders_area := $RidersArea as Area2D


var old_position : Vector2


func _physics_process(_delta : float) -> void:
	for rider in riders_area.get_overlapping_bodies():
		if rider != self and not rider.is_in_group("Projectile") and not rider.is_in_group("Platform") and rider is Entity or rider.is_in_group("Player"):
			rider.position += position - old_position
	old_position = position


func get_passengers() -> int:
	var riders_count := 0
	for rider in riders_area.get_overlapping_bodies():
		if rider != self and not rider.is_in_group("Projectile") and not rider.is_in_group("Platform") and rider is Entity or rider.is_in_group("Player"):
			riders_count += 1
	return riders_count
