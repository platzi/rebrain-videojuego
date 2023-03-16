extends Node


var save_exists := false
var save_data : Dictionary
var config_file := ConfigFile.new()


func _ready() -> void:
	_load_save()


func save() -> void:
	save_exists = true
	for section in save_data:
		for key in save_data[section]:
			config_file.set_value(section, key, save_data[section][key])
	Globals.player_name = config_file.get_value("customization", "player_name", "")
	config_file.save("user://save.dat")


func complete_level(name : String) -> void:
	save_data["levels"][name] = true
	save()


func set_config(bgm_volume : int, sfx_volume : int) -> void:
	save_data.config.bgm_volume = bgm_volume
	save_data.config.sfx_volume = sfx_volume
	save()


func _load_save() -> void:
	var err := config_file.load("user://save.dat")
	save_exists = err == OK
	save_data["levels"] = {}
	save_data["config"] = {
		"bgm_volume" : config_file.get_value("config", "bgm_volume", 50),
		"sfx_volume" : config_file.get_value("config", "sfx_volume", 50)
	}
	if config_file.has_section("levels"):
		for level in config_file.get_section_keys("levels"):
			save_data["levels"][level] = true
	save_data["customization"] = {
		"player_name" : config_file.get_value("customization", "player_name", ""),
		"hair_style" : config_file.get_value("customization", "hair_style", 0),
		"hair_color" : config_file.get_value("customization", "hair_color", 0),
		"skin_color" : config_file.get_value("customization", "skin_color", 0),
		"shirt_color" : config_file.get_value("customization", "shirt_color", 0),
		"pants_color" : config_file.get_value("customization", "pants_color", 7),
		"shoes_color" : config_file.get_value("customization", "shoes_color", 0),
	}
	save_data["extras"] = {
		"version" : config_file.get_value("extras", "version", "0.1.0")
	}
	Globals.player_name = config_file.get_value("customization", "player_name", "")
