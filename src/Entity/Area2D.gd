extends Area2D


func _input(event):
	if event is InputEventMouseButton:
		#left: 1, right: 2
		if event.button_index == BUTTON_LEFT:
			print(self.get_parent().brain)
			print(self.get_parent().brain.brain)
