extends Entity


onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var visibility_notifier := $VisibilityNotifier2D as VisibilityNotifier2D


func _ready():
	animation_player.play("Spin")
	visibility_notifier.connect("screen_exited", self, "_on_screen_exited")


func _on_screen_exited() -> void:
	queue_free()


func _on_collision(collision : KinematicCollision2D) -> void:
	if collision.collider.is_in_group("Player") || collision.collider.is_in_group("Enemy") || collision.collider.is_in_group("Friend"):
		collision.collider.hurt(Vector2(1.0, 0.0).rotated(collision.collider.position.angle_to_point(position)))
	if "Barrel" in collision.collider.name:
		collision.collider.queue_free()
	queue_free()
