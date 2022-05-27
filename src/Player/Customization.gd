extends Node2D

signal change_hair
signal change_skin_color
signal change_shirt
signal change_pants
signal change_shoes


onready var change_hair_prev_btn : = $VBoxContainer/HBoxContainer/ChangeHairPrevBtn
onready var change_hair_next_btn : = $VBoxContainer/HBoxContainer/ChangeHairNextBtn
onready var hair_label : = $VBoxContainer/HBoxContainer/HairLabel

onready var change_skin_color_prev_btn : = $VBoxContainer/HBoxContainer2/ChangeSkinColorPrevBtn
onready var change_skin_color_next_btn : = $VBoxContainer/HBoxContainer2/ChangeSkinColorNextBtn
onready var skin_color_rect : = $VBoxContainer/HBoxContainer2/SkinColorRect

onready var change_shirt_prev_btn : = $VBoxContainer/HBoxContainer3/ChangeShirtPrevBtn
onready var change_shirt_next_btn : = $VBoxContainer/HBoxContainer3/ChangeShirtNextBtn
onready var shirt_color_rect : = $VBoxContainer/HBoxContainer3/ShirtColorRect

onready var change_pants_prev_btn : = $VBoxContainer/HBoxContainer4/ChangePantsPrevBtn
onready var change_pants_next_btn : = $VBoxContainer/HBoxContainer4/ChangePantsNextBtn
onready var pants_color_rect : = $VBoxContainer/HBoxContainer4/PantsColorRect

onready var change_shoes_prev_btn : = $VBoxContainer/HBoxContainer5/ChangeShoesPrevBtn
onready var change_shoes_next_btn : = $VBoxContainer/HBoxContainer5/ChangeShoesNextBtn
onready var shoes_color_rect : = $VBoxContainer/HBoxContainer5/ShoesColorRect

var all_hairs = [
	preload("res://assets/images/player/hair_01.png"),
	preload("res://assets/images/player/hair_02.png")
]
var skin_colors = [
	Color.peachpuff,
	Color.black,
	Color.blue,
	Color.brown,
	Color.gold,
	Color.gray,
	Color.green,
	Color.orange,
	Color.pink,
	Color.purple,
	Color.red,
	Color.tomato,
	Color.violet,
	Color.white,
	Color.yellow
]
var clothes_colors = [
	Color.aliceblue,
	Color.aqua,
	Color.aquamarine,
	Color.azure,
	Color.black,
	Color.blue,
	Color.brown,
	Color.gold,
	Color.gray,
	Color.green,
	Color.orange,
	Color.pink,
	Color.purple,
	Color.red,
	Color.tomato,
	Color.violet,
	Color.white,
	Color.yellow,
	Color.yellowgreen
]
var current_hair : int = 0 
var current_skin_color : int = 0
var current_shirt : int = 0
var current_pants : int = 0
var current_shoes : int = 0


func _on_ChangeHairPrevBtn_pressed():
	current_hair = (all_hairs.size() + current_hair - 1) % all_hairs.size()
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	emit_signal("change_hair", all_hairs[current_hair])


func _on_ChangeHairNextBtn_pressed():
	current_hair = (current_hair + 1) % all_hairs.size()
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	emit_signal("change_hair", all_hairs[current_hair])


func _on_ChangeSkinColorPrevBtn_pressed():
	current_skin_color = (skin_colors.size() + current_skin_color - 1) % skin_colors.size()
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	emit_signal("change_skin_color", skin_colors[current_skin_color])


func _on_ChangeSkinColorNextBtn_pressed():
	current_skin_color = (current_skin_color + 1) % skin_colors.size()
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	emit_signal("change_skin_color", skin_colors[current_skin_color])


func _on_ChangeShirtPrevBtn_pressed():
	current_shirt = (clothes_colors.size() + current_shirt - 1) % clothes_colors.size()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	emit_signal("change_shirt", clothes_colors[current_shirt])


func _on_ChangeShirtNextBtn_pressed():
	current_shirt = (current_shirt + 1) % clothes_colors.size()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	emit_signal("change_shirt", clothes_colors[current_shirt])


func _on_ChangePantsPrevBtn_pressed():
	current_pants = (clothes_colors.size() + current_pants - 1) % clothes_colors.size()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	emit_signal("change_pants", clothes_colors[current_pants])


func _on_ChangePantsNextBtn_pressed():
	current_pants = (current_pants + 1) % clothes_colors.size()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	emit_signal("change_pants", clothes_colors[current_pants])


func _on_ChangeShoesPrevBtn_pressed():
	current_shoes = (clothes_colors.size() + current_shoes - 1) % clothes_colors.size()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	emit_signal("change_shoes", clothes_colors[current_shoes])


func _on_ChangeShoesNextBtn_pressed():
	current_shoes = (current_shoes + 1) % clothes_colors.size()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	emit_signal("change_shoes", clothes_colors[current_shoes])


func _ready():
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	change_hair_prev_btn.connect("pressed", self, "_on_ChangeHairPrevBtn_pressed")
	change_hair_next_btn.connect("pressed", self, "_on_ChangeHairNextBtn_pressed")
	change_skin_color_prev_btn.connect("pressed", self, "_on_ChangeSkinColorPrevBtn_pressed")
	change_skin_color_next_btn.connect("pressed", self, "_on_ChangeSkinColorNextBtn_pressed")
	change_shirt_prev_btn.connect("pressed", self, "_on_ChangeShirtPrevBtn_pressed")
	change_shirt_next_btn.connect("pressed", self, "_on_ChangeShirtNextBtn_pressed")
	change_pants_prev_btn.connect("pressed", self, "_on_ChangePantsPrevBtn_pressed")
	change_pants_next_btn.connect("pressed", self, "_on_ChangePantsNextBtn_pressed")
	change_shoes_prev_btn.connect("pressed", self, "_on_ChangeShoesPrevBtn_pressed")
	change_shoes_next_btn.connect("pressed", self, "_on_ChangeShoesNextBtn_pressed")

