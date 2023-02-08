extends Node


var save_exists := false
var save_data : Dictionary
var config_file := ConfigFile.new()


func _ready() -> void:
	_load_save()


func save() -> void:
	for section in save_data:
		for key in save_data[section]:
			config_file.set_value(section, key, save_data[section][key])
	config_file.save("user://save.dat")


func _load_save() -> void:
	var err := config_file.load("user://save.dat")
	save_exists = err == OK
	save_data["extas"] = {
		"version" : config_file.get_value("extra", "version", "0.1.0")
	}
	save_data["customization"] = {
		"player_name" : config_file.get_value("customization", "player_name", ""),
		"hair_style" : config_file.get_value("customization", "hair_style", 0),
		"hair_color" : config_file.get_value("customization", "hair_color", 0),
		"skin_color" : config_file.get_value("customization", "skin_color", 0),
		"shirt_color" : config_file.get_value("customization", "shirt_color", 0),
		"pants_color" : config_file.get_value("customization", "pants_color", 7),
		"shoes_color" : config_file.get_value("customization", "shoes_color", 0),
	}
