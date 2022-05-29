tool

extends Control

export(int) var lives = 3 setget _set_lives


onready var hearts_tr = [
	$MarginContainer/HBoxContainer/HeartTR,
	$MarginContainer/HBoxContainer/HeartTR2,
	$MarginContainer/HBoxContainer/HeartTR3
]

func _ready():
	Globals.connect("update_life", self, "_set_lives")


func _set_lives(new_value : int) -> void:
	lives = new_value
	for i in range(hearts_tr.size()):
		hearts_tr[i].texture = load("res://assets/images/ui/heart-empty.png")
	for i in range(lives):
		hearts_tr[i].texture = load("res://assets/images/ui/heart-full.png")
