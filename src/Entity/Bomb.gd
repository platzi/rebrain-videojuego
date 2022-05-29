extends Entity


var is_exploding = false


func _ready():
	speed = 40


func _physics_process(delta):
	if is_exploding:
		for body in $ExplosionArea.get_overlapping_bodies():
			_on_Area2D_body_entered(body)
		queue_free()

func activate_explosion():
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	is_exploding = true
