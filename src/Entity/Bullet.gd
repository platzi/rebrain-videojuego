extends KinematicBody2D


var velocity_vector = Vector2.ZERO
var speed = 200
var collision = null
onready var max_x = get_viewport().get_visible_rect().size.x
onready var max_y = get_viewport().get_visible_rect().size.y


func shoot(velocity : Vector2) -> void:
	velocity_vector = velocity


func hit() -> void:
	queue_free()


func _physics_process(delta : float) -> void:
	if velocity_vector != Vector2.ZERO:
		collision = move_and_collide(velocity_vector * delta * speed)
		if collision:
			hit()
			var collider = collision.get_collider()
			if collider.is_in_group("Player"):
				collider.hurt(velocity_vector)
			elif collider.is_in_group("Entity"):
				collider.hurt(velocity_vector)
	var _x = get_position().x
	var _y = get_position().y
	if _x < 0 or _x > max_x or _y < 0 or _y > max_y:
		hit()
