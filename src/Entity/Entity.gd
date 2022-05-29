class_name Entity


extends KinematicBody2D


signal button_body_entered


var brain_dict := {}
export (String) var brain_og


onready var animation_tree = $AnimationTree
onready var message_board = $MessageBoard
onready var area_2D = $Area2D
export var move_vector = Vector2.DOWN
onready var animation_state = animation_tree.get("parameters/playback")
onready var velocity_vector = animation_tree.get("parameters/Idle/blend_position")

var brain := Brain.new()

var moving = false
var speed = 100
var cool_down = 1
var _timer = null
var inmunity_timer = null
var is_shooting = false
var life = 3
var inmunity = false
var inmunity_time = 1
var max_speed = 100
var projectile_owner = null
var is_open = false
var change_scene : PackedScene = PackedScene.new()
var initial_postion : Vector2 = Vector2.ZERO
var initial_direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	initial_postion = position
	initial_direction = move_vector
	animation_tree.set("parameters/Idle/blend_position", move_vector)
	animation_tree.set("parameters/Move/BlendSpace2D/blend_position", move_vector)
	inmunity_timer = Timer.new()
	add_child(inmunity_timer)
	inmunity_timer.connect("timeout", self, "remove_inmunity")
	inmunity_timer.set_wait_time(inmunity_time)
	inmunity_timer.set_one_shot(true)
	
	area_2D.connect("body_entered", self, "_on_Area2D_body_entered")
	area_2D.connect("body_exited", self, "_on_Area2D_body_exited")
	instance_brain()


func _input(event) -> void:
	if event is InputEventKey and event.scancode == KEY_0 and not self.is_in_group("Projectile"):
		shoot()
	elif event is InputEventKey and event.scancode == KEY_SPACE and self.is_in_group("Teleporter"):
		activate()
	elif event is InputEventKey and event.scancode == KEY_CONTROL:
		reset_position()


func _physics_process(delta : float) -> void:
	if area_2D.get_overlapping_bodies() != []:
		_on_Area2D_body_entered(area_2D.get_overlapping_bodies()[0])
	if moving:
		if self.is_in_group("Projectile"):
			velocity_vector = move_vector * speed
		else:
			animation_tree.set("parameters/Move/BlendSpace2D/blend_position", move_vector)
			animation_state.travel("Move")
			velocity_vector += move_vector * speed
			if velocity_vector.distance_to(Vector2.ZERO) > max_speed:
				velocity_vector = velocity_vector.move_toward(move_vector * max_speed, delta * max_speed * 100)
	else:
		velocity_vector = velocity_vector.move_toward(Vector2.ZERO, delta * max_speed * 100)
		animation_state.travel("Idle")
	velocity_vector = move_and_slide(velocity_vector)


func instance_brain():
	brain.connect("move_forward", self, "move_forward")
	brain.connect("stop_moving", self, "stop_moving")
	brain.connect("turns_towards", self, "turns_towards")
	brain.connect("shoot", self, "shoot")
	brain.connect("show_message", self, "show_message")
	brain.connect("hide_message", self, "hide_message")
	brain.brain = brain_dict
	add_child(brain)


func turns_towards(towards : String) -> void:
	if towards.to_lower() == "left":
		#(1, 0) -> (0, -1) -> (-1, 0) -> (0, 1)
		#(-1, -1) -- (-1, 1) -- (1, 1) -- (1, -1)
		if move_vector.x > 0:
			move_vector += Vector2(-1, -1)
		elif move_vector.x < 0:
			move_vector += Vector2(1, 1)
		elif move_vector.y > 0:
			move_vector += Vector2(1, -1)
		elif move_vector.y < 0:
			move_vector += Vector2(-1, 1)
	elif towards.to_lower() == "right":
		#(1, 0) -> (0, 1) -> (-1, 0) -> (0, -1)
		#(-1, 1) -- (-1, -1) -- (1, -1) -- (1, 1)
		if move_vector.x > 0:
			move_vector += Vector2(-1, 1)
		elif move_vector.x < 0:
			move_vector += Vector2(1, -1)
		elif move_vector.y > 0:
			move_vector += Vector2(-1, -1)
		elif move_vector.y < 0:
			move_vector += Vector2(1, 1)
	animation_tree.set("parameters/Idle/blend_position", move_vector)


func move_forward() -> void:
	moving = true


func stop_moving() -> void:
	moving = false


func show_message(text : String) -> void:
	message_board.set_text(text)
	message_board.show_message()


func hide_message() -> void:
	message_board.hide_message()


func shoot() -> void:
	if not is_shooting:
		is_shooting = true
		var bullet = load("res://src/Entity/Bullet.tscn").instance()
		bullet.projectile_owner = self.get_instance_id()
		bullet.position = self.position + (move_vector * 40)
		get_tree().current_scene.add_child(bullet)
		bullet.shoot_projectile(move_vector)
		start_shooting()


func start_shooting() -> void:
	#shoot()
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "stop_shooting")
	_timer.set_wait_time(cool_down)
	_timer.set_one_shot(true)
	_timer.start()


func stop_shooting() -> void:
	_timer.queue_free()
	_timer = null
	is_shooting = false


func remove_inmunity() -> void:
	inmunity = false
	$HitAnimationPlayer.play("RESET")


func hurt(knockback_direction : Vector2 = Vector2.ZERO) -> void:
	if not inmunity:
		inmunity = true
		life -= 1
		velocity_vector = knockback_direction * max_speed * 8
		inmunity_timer.start(inmunity_time)
		$HitAnimationPlayer.play("Hit")
	if life < 1:
		queue_free()


func _on_Area2D_body_entered(body) -> void:
	if body.get_instance_id() == self.get_instance_id():
		return
	if self.is_in_group("Projectile"):
		self.hurt()
	
	if self.is_in_group("Teleporter") and body.is_in_group("Player") and is_open:
		print("Teleporter")
		get_tree().change_scene_to(change_scene)
	elif not self.is_in_group("EntityStatic") and body.is_in_group("Player"):
		body.hurt(position.direction_to(body.position))
	elif (
		body.is_in_group("Projectile") 
		and body.projectile_owner != self.get_instance_id()
		and self.is_in_group("Projectile")
	):
		body.hurt()
	elif self.is_in_group("EntityButton"):
		emit_signal("button_body_entered")
		$AnimationPlayer.play("ButtonPressed")
	elif body.is_in_group("Entity") and body.projectile_owner == self.get_instance_id():
		return
	elif (
		self.is_in_group("Projectile") 
		and body.is_in_group("Entity") 
		and not body.is_in_group("EntityStatic")
	):
		body.hurt(position.direction_to(body.position))


func _on_Area2D_body_exited(body) -> void:
	pass


func activate() -> void:
	$AnimationPlayer.play("Open")
	is_open = true


func set_change_scene(target_scene : PackedScene) -> void:
	change_scene = target_scene


func reset_position() -> void:
	position = initial_postion
	move_vector = initial_direction
	moving = false
	hide_message()
	remove_inmunity()
	life = 3
	animation_tree.set("parameters/Idle/blend_position", move_vector)
	animation_tree.set("parameters/Move/BlendSpace2D/blend_position", move_vector)
	brain.queue_free()
	brain = Brain.new()
	instance_brain()
