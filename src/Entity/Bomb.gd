extends Entity

var particle_scene := load("res://src/Particles/Explosion.tscn")

var is_exploding = false


func _ready():
	speed = 40


func _physics_process(delta):
	if is_exploding:
		for body in $ExplosionArea.get_overlapping_bodies():
			_on_Area2D_body_entered(body)


func activate_explosion():
	brain.stop()
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	is_exploding = true
	var timer := Timer.new()
	timer.connect("timeout", self, "destroy")
	add_child(timer)
	timer.start(0.1)
	var particle_inst = particle_scene.instance()
	particle_inst.position = position
	get_parent().add_child(particle_inst)
