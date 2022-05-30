extends CPUParticles2D


func _ready():
	emitting = true
	var timer := Timer.new()
	timer.connect("timeout", self, "queue_free")
	timer.start(5)
	add_child(timer)
