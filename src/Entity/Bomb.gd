extends Entity


var is_exploding = false


func _ready():
	speed = 40


func _physics_process(delta):
	if $ExplosionArea.get_overlapping_bodies() != [] and is_exploding:
		for i in len($ExplosionArea.get_overlapping_bodies()):
			_on_Area2D_body_entered($ExplosionArea.get_overlapping_bodies()[i])
		#print($ExplosionArea.get_overlapping_bodies()[1])
		queue_free()

func activate_explosion():
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	is_exploding = true
