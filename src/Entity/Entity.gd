class_name Entity


extends KinematicBody2D


enum NODE_TYPES {
	UPDATE,
	COLLISION,
	TRIGGER,
	PRESSED,
	RELEASED,
	
	MOVE_FORWARD,
	ROTTATE_LEFT,
	ROTATE_RIGHT
	TIMER,
	SHOOT,
	SHOOT_TRIGGER,
	OPEN,
	CLOSE,
	
	IF,
	AND,
	OR,
	EQUAL,
	NOT_EQUAL,
	GREATER,
	GREATER_EQUAL,
	LESS,
	LESS_EQUAL,
	COMPARE_ENTITY,
	COMPARE_STRING,
	
	NUMBER,
	STRING,
	BOOL,
	ENTITY,
	
	POSITION,
	DIRECTION
}


export (String) var brain_og

export (PackedScene) var death_particles
export (Vector2) var death_particles_offset
export (int) var life := 3
export (float, 0.0, 360.0) var direction
export (bool) var blocked


var nodes_limit : Dictionary

var message_board
var hurt_box
var hit_box

var brain_dict := {}
var brain := Brain.new()

var speed := 0.0
var cool_down = 1
var _timer = null
var is_shooting = false
var max_speed = 100
var projectile_owner = null
var initial_postion : Vector2 = Vector2.ZERO
var initial_direction := 0.0
var velocity_vector : Vector2 = Vector2(0.0, 0.0)

func _ready() -> void:
	set_nodes()
	# Load default brain
	if brain_og != "":
		var result = JSON.parse(brain_og)
		if result.error == OK:
			brain_dict = result.result
	# Set initial position and direction
	initial_postion = position
	initial_direction = direction
	# Connection for the global trigger
	Globals.connect("trigger_global", self, "_on_trigger_received")
	# Instance the brain and make all connections
	instance_brain()
	if Engine.editor_hint:
		set_physics_process(false)
		set_process(false)


func _physics_process(delta : float) -> void:
	if speed != 0.0:
		var linear_veolicty := Vector2.RIGHT.rotated(deg2rad(direction)) * speed
		move_and_slide(linear_veolicty)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		_on_collision(collision)


func _get_property_list() -> Array:
	var properties := []
	properties.append({
		name = "Nodes List",
		type = TYPE_NIL,
		hint = "nodes_limit_",
		usage = PROPERTY_USAGE_GROUP
	})
	for i in NODE_TYPES:
		properties.append({
			name = "node_limit_" + str(i),
			type = TYPE_INT
		})
	return properties

func _get(property : String):
	if "node_limit_" in property:
		var property_split = property.trim_prefix("node_limit_")
		if NODE_TYPES.has(property_split):
			if nodes_limit.has(property_split):
				return nodes_limit[property_split]
			else:
				return 0


func _set(property : String, value) -> bool:
	if "node_limit_" in property:
		var property_split = property.trim_prefix("node_limit_")
		if NODE_TYPES.has(property_split):
			nodes_limit[property_split] = value
			return true
	return false


func set_nodes() -> void:
	message_board = get_node_or_null("MessageBoard")
	hurt_box = get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.connect("hurt", self, "hurt")
	hit_box = get_node_or_null("HitBox")
	if hit_box:
		hit_box.connect("hit", self, "_on_hit")


func instance_brain() -> void:
	brain.connect("move_forward", self, "move_forward")
	brain.connect("stop_moving", self, "stop_moving")
	brain.connect("turns_towards", self, "turns_towards")
	brain.connect("shoot", self, "_shoot")
	brain.connect("show_message", self, "show_message")
	brain.connect("hide_message", self, "hide_message")
	brain.connect("explode", self, "activate_explosion")
	brain.connect("activate", self, "activate")
	brain.connect("open", self, "open")
	brain.connect("close", self, "close")
	brain.brain = brain_dict
	add_child(brain)


func turns_towards(towards : String) -> void:
	if towards.to_lower() == "left":
		direction = fmod(direction - 90.0 + 360.0, 360.0)
	elif towards.to_lower() == "right":
		direction = fmod(direction + 90.0, 360.0)


func move_forward() -> void:
	speed = 48.0


func stop_moving() -> void:
	speed = 0.0


func show_message(text : String) -> void:
	message_board.set_text(text)
	message_board.show_message()


func hide_message() -> void:
	message_board.hide_message()


func _shoot() -> void:
	pass


func open() -> void:
	pass


func close() -> void:
	pass


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


func hurt(knockback_direction : Vector2 = Vector2.ZERO) -> void:
	life -= 1
	velocity_vector = knockback_direction * max_speed * 8
	if life <= 0:
		destroy()
	_on_hurt()


func _on_hurt() -> void:
	pass


func _on_hit() -> void:
	pass


func activate() -> void:
	pass


func reset_position() -> void:
	position = initial_postion
	direction = initial_direction
	velocity_vector = Vector2.RIGHT.rotated(deg2rad(direction))
	speed = 0.0
	if message_board:
		message_board.reset()
	life = 3
	brain.queue_free()
	brain = Brain.new()
	instance_brain()


func activate_explosion():
	pass


func _on_trigger_received(tag : String) -> void:
	brain.run("TRIGGER", tag)


func destroy() -> void:
	if death_particles:
		var death_particles_inst = death_particles.instance()
		death_particles_inst.position = position + death_particles_offset
		get_parent().add_child(death_particles_inst)
	brain.stop()
	yield(get_tree(), "idle_frame")
	queue_free()


func _on_collision(collision : KinematicCollision2D) -> void:
	pass
