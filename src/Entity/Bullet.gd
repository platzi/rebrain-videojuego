extends Entity


var collision = null
var projectile_owner = null
onready var max_x = get_viewport().get_visible_rect().size.x
onready var max_y = get_viewport().get_visible_rect().size.y

func _ready():
	speed = 50
	moving = true


func _physics_process(delta : float) -> void:
#	if velocity_vector != Vector2.ZERO:
#		collision = move_and_collide(velocity_vector * delta * speed)
#		print(velocity_vector)
#		if collision:
#			hurt()
#			var collider = collision.get_collider()
#			if collider.is_in_group("Player"):
#				collider.hurt(velocity_vector)
#			elif collider.is_in_group("Entity"):
#				collider.hurt(velocity_vector)
	var _x = get_position().x
	var _y = get_position().y
	if _x < 0 or _x > max_x or _y < 0 or _y > max_y:
		hurt()


func hurt(knockback_direction : Vector2 = Vector2.ZERO) -> void:
	queue_free()


func shoot_projectile(velocity : Vector2) -> void:
	move_vector = velocity
	velocity_vector = velocity * 10
	
	




