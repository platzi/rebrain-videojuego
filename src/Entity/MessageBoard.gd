extends Control

onready var animation_player = $AnimationPlayer
onready var panel_container = $PanelContainer
onready var message_label = $PanelContainer/MessageLabel


func show_message() -> void:
	animation_player.play("PopUp")
	panel_container.connect("item_rect_changed", self, "_on_PanelContainer_item_rect_changed")


func reset() -> void:
	animation_player.play("RESET")


func hide_message() -> void:
	animation_player.play("PopDown")


func set_text(message : String) -> void:
	message_label.text = message


func _on_PanelContainer_item_rect_changed() -> void:
	panel_container.set_anchors_and_margins_preset(Control.PRESET_CENTER)
