extends Entity


var is_exploding = false


func _ready():
	speed = 40
	brain_dict = {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}
	brain.brain = brain_dict
	brain.run()


func _physics_process(delta):
	if $ExplosionArea.get_overlapping_bodies() != [] and is_exploding:
		for i in len($ExplosionArea.get_overlapping_bodies()):
			_on_Area2D_body_entered($ExplosionArea.get_overlapping_bodies()[i])
		#print($ExplosionArea.get_overlapping_bodies()[1])
		queue_free()

func activate_explosion():
	$ExplosionArea/CollisionShape2D.set_deferred("disabled", false)
	is_exploding = true
