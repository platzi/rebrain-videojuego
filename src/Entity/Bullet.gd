extends Entity


func _ready():
	speed = 200
	moving = true
	$Timer.connect("timeout", self, "hurt")
	$Timer.start(5)


func hurt(knockback_direction : Vector2 = Vector2.ZERO) -> void:
	queue_free()


func shoot_projectile(velocity : Vector2) -> void:
	move_vector = velocity
	velocity_vector = velocity
