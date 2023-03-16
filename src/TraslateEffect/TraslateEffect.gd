#tool


extends Node2D


export(Texture) var particle_image
export(float) var particle_scale
export(int) var sprites_count
export(Vector2) var target


onready var tween := $Tween as Tween
onready var jump_sfx := $JumpSfx as AudioStreamPlayer
onready var land_sfx := $LandSfx as AudioStreamPlayer


func _ready() -> void:
#	destroy_timer.connect("timeout", self, "_clear_sprites")
	if !Engine.editor_hint:
		tween.connect("tween_all_completed", self, "queue_free")
	_create_sprites()
	jump_sfx.play()
	get_tree().create_timer(0.3).connect("timeout", land_sfx, "play")


func _clear_sprites() -> void:
	for child in get_children():
		if child is Sprite:
			child.queue_free()


func _create_sprites() -> void:
	for i in range(sprites_count):
		# CREATE SPRITE
		var sprite = Sprite.new()
		sprite.texture = particle_image
		sprite.scale = Vector2(particle_scale, particle_scale)
		add_child(sprite)
		# ADD TWEEN
		var dir = deg2rad((360.0 / sprites_count) * i)
		var spread_position_1 = Vector2(cos(dir) * 50.0, sin(dir) * 50.0)
		var spread_position_2 = Vector2(cos(dir + 0.785) * 100.0, sin(dir + 0.785) * 100.0)
		tween.interpolate_property(sprite, "position", Vector2(0.0, 0.0), spread_position_1, 0.125, Tween.TRANS_EXPO, Tween.EASE_IN)
		tween.interpolate_property(sprite, "position", spread_position_1, spread_position_2, 0.125, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.125)
		tween.interpolate_property(sprite, "position", spread_position_2, target, 0.25, Tween.TRANS_EXPO, Tween.EASE_IN, 0.25)
		tween.interpolate_property(sprite, "scale", Vector2(particle_scale, particle_scale), Vector2(particle_scale * 2.0, particle_scale * 2.0), 0.25, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property(sprite, "scale", Vector2(particle_scale * 2.0, particle_scale * 2.0), Vector2(particle_scale, particle_scale), 0.25, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.25)
	tween.start()
