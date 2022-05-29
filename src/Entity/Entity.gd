class_name Entity


extends KinematicBody2D


signal button_body_entered


var brain_dict := {}


onready var animation_tree = $AnimationTree
onready var message_board = $MessageBoard
onready var area_2D = $Area2D
onready var move_vector = animation_tree.get("parameters/Idle/blend_position")
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
const MAX_SPEED = 100


func _ready() -> void:
	inmunity_timer = Timer.new()
	add_child(inmunity_timer)
	inmunity_timer.connect("timeout", self, "remove_inmunity")
	inmunity_timer.set_wait_time(inmunity_time)
	inmunity_timer.set_one_shot(true)
	
	area_2D.connect("body_entered", self, "_on_Area2D_body_entered")
	
	brain.connect("move_forward", self, "move_forward")
	brain.connect("stop_moving", self, "stop_moving")
	brain.connect("turns_towards", self, "turns_towards")
	brain.connect("shoot", self, "shoot")
	brain.connect("show_message", self, "show_message")
	brain.connect("hide_message", self, "hide_message")
	brain.brain = brain_dict
	add_child(brain)

func _input(event):
	if event is InputEventKey and event.scancode == KEY_0 and not self.is_in_group("Projectile"):
		shoot()


func _physics_process(delta : float) -> void:
	if area_2D.get_overlapping_bodies() != []:
		_on_Area2D_body_entered(area_2D.get_overlapping_bodies()[0])
	if moving:
		animation_tree.set("parameters/Move/BlendSpace2D/blend_position", move_vector)
		animation_state.travel("Move")
		velocity_vector += move_vector * speed
		if velocity_vector.distance_to(Vector2.ZERO) > MAX_SPEED:
			velocity_vector = velocity_vector.move_toward(move_vector * MAX_SPEED, delta * MAX_SPEED * 100)
#		position += velocity_vector * delta
#		for i in get_slide_count():
#			var collision = get_slide_collision(i)
#			if collision.collider.is_in_group("Projectile"):
#				collision.collider.hit()
#				hurt(move_vector)
#			elif collision.collider.is_in_group("Player"):
#				collision.collider.hurt(move_vector)
	else:
		velocity_vector = velocity_vector.move_toward(Vector2.ZERO, delta * MAX_SPEED * 100)
		animation_state.travel("Idle")
	velocity_vector = move_and_slide(velocity_vector)


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


func hurt(knockback_direction : Vector2 = Vector2.ZERO) -> void:
	if not inmunity:
		inmunity = true
		life -= 1
		velocity_vector = knockback_direction * MAX_SPEED * 10
		inmunity_timer.start(inmunity_time)
		$HitAnimationPlayer.play("Hit")


func _on_Area2D_body_entered(body):
	if self.is_in_group("Projectile"):
		self.hurt()
	if not self.is_in_group("EntityStatic") and body.is_in_group("Player"):
		body.hurt(position.direction_to(body.position))
		#print(self.name)
	elif body.is_in_group("Projectile") and body.projectile_owner != self.get_instance_id():
			body.hit()
	elif self.is_in_group("EntityButton"):
		#print("BUTTONNN")
		emit_signal("button_body_entered")
	elif body.projectile_owner == self.get_instance_id():
		pass
	elif not self.is_in_group("EntityStatic") and not self.is_in_group("Projectile"):
		hurt(body.position.direction_to(position))
