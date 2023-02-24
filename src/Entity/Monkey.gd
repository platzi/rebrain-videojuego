tool


extends Entity


const projectile_scene := preload("res://src/Entity/Banana.tscn")


onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	if Engine.editor_hint:
		set_process(false)
		_process(0.0)


func _process(_delta : float) -> void:
	print(direction)
	if speed != 0.0:
		if direction == 0.0 || direction == 360.0:
			animation_player.play("MoveRight")
		elif direction == 90.0:
			animation_player.play("MoveDown")
		elif direction == 180.0:
			animation_player.play("MoveLeft")
		elif direction == 270.0:
			animation_player.play("MoveUp")
	else:
		if direction == 0.0 || direction == 360.0:
			animation_player.play("IdleRight")
		elif direction == 90.0:
			animation_player.play("IdleDown")
		elif direction == 180.0:
			animation_player.play("IdleLeft")
		elif direction == 270.0:
			animation_player.play("IdleUp")


func _shoot() -> void:
	var lx := sin(deg2rad(direction + 90)) * 30
	var ly := cos(deg2rad(direction - 90)) * 30
	var projectile_inst := projectile_scene.instance() as Entity
	get_parent().add_child(projectile_inst)
	projectile_inst.blocked = true
	projectile_inst.position = position + Vector2(lx, ly)
	projectile_inst.speed = 300
	projectile_inst.direction = direction
