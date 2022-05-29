extends Entity


func _ready():
	speed = 80
	cool_down = 2
	brain_dict = {"RotateNode":{"type":"ROTATE","position":[220,40],"connections":[{"from_port":0,"to":"MoveForwardNode","to_port":0}],"params":[1]},"UpdateNode":{"type":"UPDATE","position":[20,60],"connections":[{"from_port":0,"to":"RotateNode","to_port":0}],"params":[]},"MoveForwardNode":{"type":"MOVE_FORWARD","position":[420,40],"connections":[{"from_port":0,"to":"TimerNode","to_port":0}],"params":[2]},"TimerNode":{"type":"TIMER","position":[620,40],"connections":[{"from_port":0,"to":"ShootNode","to_port":0}],"params":[5]},"ShootNode":{"type":"SHOOT","position":[820,60],"connections":[{"from_port":0,"to":"MessageNode","to_port":0}],"params":[]},"MessageNode":{"type":"MESSAGE","position":[1020,20],"connections":[],"params":["Toma idiota",3]}}
	brain.brain = brain_dict
	brain.run()
