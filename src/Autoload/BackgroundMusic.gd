extends AudioStreamPlayer


export(AudioStream) var game_bgm
export(AudioStream) var menu_bgm


var bgm_idx : int
var sfx_idx : int


func _ready() -> void:
	bgm_idx = AudioServer.get_bus_index("Bgm")
	sfx_idx = AudioServer.get_bus_index("Sfx")
	set_bgm_volume(SaveManager.save_data.config.bgm_volume)
	set_sfx_volume(SaveManager.save_data.config.sfx_volume)


func play_game_bgm() -> void:
	if stream != game_bgm:
		stream = game_bgm
		play()


func play_menu_bgm() -> void:
	if stream != menu_bgm:
		deactivate_eq()
		stream = menu_bgm
		play()


func set_bgm_volume(volume : int) -> void:
	AudioServer.set_bus_volume_db(bgm_idx, linear2db(volume * 0.01))


func set_sfx_volume(volume : int) -> void:
	AudioServer.set_bus_volume_db(sfx_idx, linear2db(volume * 0.01))


func activate_eq() -> void:
	AudioServer.set_bus_effect_enabled(bgm_idx, 0, true)


func deactivate_eq() -> void:
	AudioServer.set_bus_effect_enabled(bgm_idx, 0, false)
