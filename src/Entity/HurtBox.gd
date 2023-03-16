tool


extends Area2D


signal hurt


export(float) var inmunity_time := 1.0 setget _set_inmunity_time
export(Shape2D) var shape setget _set_shape
export(NodePath) var blink_sprite_path


onready var collision_shape_2d := $CollisionShape2D as CollisionShape2D
onready var immunity_timer := $ImmunityTimer as Timer
onready var blink_timer := $BlinkTimer as Timer
onready var blink_sprite := get_node_or_null(blink_sprite_path) as Sprite

var blink_sprites : Array


func _ready() -> void:
	immunity_timer.connect("timeout", self, "_on_immunity_timer_timeout")
	blink_timer.connect("timeout", self, "_blink")
	connect("area_entered", self, "_on_area_entered")
	_set_shape(shape)
	_set_inmunity_time(inmunity_time)


func _blink() -> void:
	if blink_sprite:
		blink_sprite.visible = !blink_sprite.visible


func _on_immunity_timer_timeout() -> void:
	monitoring = true
	monitorable = true
	blink_timer.stop()
	if blink_sprite:
		blink_sprite.visible = true


func _on_area_entered(area : Area2D) -> void:
	if area.get_parent() != get_parent() and area.is_in_group("HitBox"):
		var knockback_direction = (global_position - area.global_position).normalized()
		emit_signal("hurt", knockback_direction)
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		immunity_timer.start()
		blink_timer.start()
		if blink_sprite:
			blink_sprite.visible = false


func _set_shape(new_value : Shape2D) -> void:
	shape = new_value
	if collision_shape_2d:
		collision_shape_2d.shape = shape


func _set_inmunity_time(new_value : float) -> void:
	inmunity_time = new_value
	if immunity_timer:
		immunity_timer.wait_time = inmunity_time
