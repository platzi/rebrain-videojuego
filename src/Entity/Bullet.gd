extends KinematicBody2D


var velocity_vector = Vector2.ZERO
var speed = 200
var collision = null


func shoot(velocity : Vector2) -> void:
	velocity_vector = velocity


func hit() -> void:
	queue_free()


func _physics_process(delta : float) -> void:
	if velocity_vector != Vector2.ZERO:
		collision = move_and_collide(velocity_vector * delta * speed)
		if collision:
			hit()
