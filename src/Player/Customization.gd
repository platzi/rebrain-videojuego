extends Node2D

signal change_player_name
signal change_hair
signal change_hair_color
signal change_skin_color
signal change_shirt
signal change_pants
signal change_shoes


var config = ConfigFile.new()

onready var name_line_edit : = $PanelContainer/VBoxContainer/HBoxContainer0/NameLineEdit
onready var save_btn : = $PanelContainer/VBoxContainer/HBoxContainer6/SaveBtn

onready var change_hair_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer/ChangeHairPrevBtn
onready var change_hair_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer/ChangeHairNextBtn
onready var hair_label : = $PanelContainer/VBoxContainer/HBoxContainer/HairLabel

onready var change_hair_color_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer7/ChangeHairColorPrevBtn
onready var change_hair_color_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer7/ChangeHairColorNextBtn
onready var hair_color_rect : = $PanelContainer/VBoxContainer/HBoxContainer7/HairColorRect

onready var change_skin_color_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer2/ChangeSkinColorPrevBtn
onready var change_skin_color_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer2/ChangeSkinColorNextBtn
onready var skin_color_rect : = $PanelContainer/VBoxContainer/HBoxContainer2/SkinColorRect

onready var change_shirt_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer3/ChangeShirtPrevBtn
onready var change_shirt_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer3/ChangeShirtNextBtn
onready var shirt_color_rect : = $PanelContainer/VBoxContainer/HBoxContainer3/ShirtColorRect

onready var change_pants_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer4/ChangePantsPrevBtn
onready var change_pants_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer4/ChangePantsNextBtn
onready var pants_color_rect : = $PanelContainer/VBoxContainer/HBoxContainer4/PantsColorRect

onready var change_shoes_prev_btn : = $PanelContainer/VBoxContainer/HBoxContainer5/ChangeShoesPrevBtn
onready var change_shoes_next_btn : = $PanelContainer/VBoxContainer/HBoxContainer5/ChangeShoesNextBtn
onready var shoes_color_rect : = $PanelContainer/VBoxContainer/HBoxContainer5/ShoesColorRect

var all_hairs = [
	preload("res://assets/images/player/hair_01.png"),
	preload("res://assets/images/player/hair_02.png")
]
var skin_colors = [
	Color("#ffdbac"),
	Color("#f1c27d"),
	Color("#e0ac69"),
	Color("#c68642"),
	Color("#8d5524"),
	Color("#543d17"),
	Color("#a82525"),
	Color("#dac808"),
	Color("#18c017"),
	Color("#17a0c0"),
	Color("#7b17c0"),
	Color("#c0179e"),
]
var hair_colors = [
	Color("#282828"),
	Color("#5a3214"),
	Color("#ffff5a"),
	Color("#ff5050"),
	Color("#ffffff"),
	Color("#fe5caa"),
	Color("#dc95dc"),
	Color("#50b4ff"),
	Color("#11642f"),
]
var clothes_colors = [
	Color("#ffffff"),
	Color("#2c2c2c"),
	Color("#d00000"),
	Color("#be7400"),
	Color("#e0dd05"),
	Color("#5ccd16"),
	Color("#16cdc9"),
	Color("#2a4dc4"),
	Color("#7312cb"),
	Color("#cb12a1"),
]
var player_name := ""
var current_hair : int = 0
var current_hair_color : int = 0
var current_skin_color : int = 0
var current_shirt : int = 0
var current_pants : int = 0
var current_shoes : int = 0


func _ready() -> void:
	load_data()
	name_line_edit.set_text(player_name)
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	hair_color_rect.color = hair_colors[current_hair_color].to_rgba32()
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	change_hair_prev_btn.connect("pressed", self, "_on_ChangeHairPrevBtn_pressed")
	change_hair_next_btn.connect("pressed", self, "_on_ChangeHairNextBtn_pressed")
	change_hair_color_prev_btn.connect("pressed", self, "_on_ChangeHairColorPrevBtn_pressed")
	change_hair_color_next_btn.connect("pressed", self, "_on_ChangeHairColorNextBtn_pressed")
	change_skin_color_prev_btn.connect("pressed", self, "_on_ChangeSkinColorPrevBtn_pressed")
	change_skin_color_next_btn.connect("pressed", self, "_on_ChangeSkinColorNextBtn_pressed")
	change_shirt_prev_btn.connect("pressed", self, "_on_ChangeShirtPrevBtn_pressed")
	change_shirt_next_btn.connect("pressed", self, "_on_ChangeShirtNextBtn_pressed")
	change_pants_prev_btn.connect("pressed", self, "_on_ChangePantsPrevBtn_pressed")
	change_pants_next_btn.connect("pressed", self, "_on_ChangePantsNextBtn_pressed")
	change_shoes_prev_btn.connect("pressed", self, "_on_ChangeShoesPrevBtn_pressed")
	change_shoes_next_btn.connect("pressed", self, "_on_ChangeShoesNextBtn_pressed")
	save_btn.connect("pressed", self, "_on_SaveBtn_pressed")


func load_data() -> void:
	var err = config.load("user://re_brain_data.cfg")
	if err != OK:
		return

	player_name = config.get_value("Player", "player_name", "")
	current_hair = config.get_value("Player", "current_hair", 0)
	current_hair_color = config.get_value("Player", "current_hair_color", 0)
	current_skin_color = config.get_value("Player", "current_skin_color", 0)
	current_shirt = config.get_value("Player", "current_shirt", 0)
	current_pants = config.get_value("Player", "current_pants", 0)
	current_shoes = config.get_value("Player", "current_shoes", 0)


func _on_ChangeHairPrevBtn_pressed() -> void:
	current_hair = (all_hairs.size() + current_hair - 1) % all_hairs.size()
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	emit_signal("change_hair", all_hairs[current_hair])


func _on_ChangeHairNextBtn_pressed() -> void:
	current_hair = (current_hair + 1) % all_hairs.size()
	hair_label.set_text("Peinado %d" % (current_hair + 1))
	emit_signal("change_hair", all_hairs[current_hair])


func _on_ChangeHairColorPrevBtn_pressed() -> void:
	current_hair_color = (hair_colors.size() + current_hair_color - 1) % hair_colors.size()
	hair_color_rect.color = hair_colors[current_hair_color].to_rgba32()
	emit_signal("change_hair_color", hair_colors[current_hair_color])


func _on_ChangeHairColorNextBtn_pressed() -> void:
	current_hair_color = (current_hair_color + 1) % hair_colors.size()
	hair_color_rect.color = hair_colors[current_hair_color].to_rgba32()
	emit_signal("change_hair_color", hair_colors[current_hair_color])


func _on_ChangeSkinColorPrevBtn_pressed() -> void:
	current_skin_color = (skin_colors.size() + current_skin_color - 1) % skin_colors.size()
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	emit_signal("change_skin_color", skin_colors[current_skin_color])


func _on_ChangeSkinColorNextBtn_pressed() -> void:
	current_skin_color = (current_skin_color + 1) % skin_colors.size()
	skin_color_rect.color = skin_colors[current_skin_color].to_rgba32()
	emit_signal("change_skin_color", skin_colors[current_skin_color])


func _on_ChangeShirtPrevBtn_pressed() -> void:
	current_shirt = (clothes_colors.size() + current_shirt - 1) % clothes_colors.size()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	emit_signal("change_shirt", clothes_colors[current_shirt])


func _on_ChangeShirtNextBtn_pressed() -> void:
	current_shirt = (current_shirt + 1) % clothes_colors.size()
	shirt_color_rect.color = clothes_colors[current_shirt].to_rgba32()
	emit_signal("change_shirt", clothes_colors[current_shirt])


func _on_ChangePantsPrevBtn_pressed() -> void:
	current_pants = (clothes_colors.size() + current_pants - 1) % clothes_colors.size()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	emit_signal("change_pants", clothes_colors[current_pants])


func _on_ChangePantsNextBtn_pressed() -> void:
	current_pants = (current_pants + 1) % clothes_colors.size()
	pants_color_rect.color = clothes_colors[current_pants].to_rgba32()
	emit_signal("change_pants", clothes_colors[current_pants])


func _on_ChangeShoesPrevBtn_pressed() -> void:
	current_shoes = (clothes_colors.size() + current_shoes - 1) % clothes_colors.size()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	emit_signal("change_shoes", clothes_colors[current_shoes])


func _on_ChangeShoesNextBtn_pressed() -> void:
	current_shoes = (current_shoes + 1) % clothes_colors.size()
	shoes_color_rect.color = clothes_colors[current_shoes].to_rgba32()
	emit_signal("change_shoes", clothes_colors[current_shoes])


func _on_SaveBtn_pressed() -> void:
	config.set_value("Player", "player_name", name_line_edit.get_text())
	config.set_value("Player", "current_hair", current_hair)
	config.set_value("Player", "current_hair_color", current_hair_color)
	config.set_value("Player", "current_skin_color", current_skin_color)
	config.set_value("Player", "current_shirt", current_shirt)
	config.set_value("Player", "current_pants", current_pants)
	config.set_value("Player", "current_shoes", current_shoes)
	config.save("user://re_brain_data.cfg")
	hide()
	emit_signal("change_player_name", name_line_edit.get_text())
