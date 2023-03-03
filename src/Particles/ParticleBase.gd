extends CPUParticles2D


func _ready():
	emitting = true
	var timer := Timer.new()
	timer.connect("timeout", self, "queue_free")
	timer.autostart = true
	timer.wait_time = 5
	add_child(timer)
