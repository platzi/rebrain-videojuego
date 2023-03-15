extends AudioStreamPlayer


export(AudioStream) var game_bgm
export(AudioStream) var menu_bgm


var bgm_idx : int


func _ready() -> void:
	bgm_idx = AudioServer.get_bus_index("Bgm")


func play_game_bgm() -> void:
	if stream != game_bgm:
		stream = game_bgm
		play()


func play_menu_bgm() -> void:
	if stream != menu_bgm:
		deactivate_eq()
		stream = menu_bgm
		play()


func activate_eq() -> void:
	AudioServer.set_bus_effect_enabled(bgm_idx, 0, true)


func deactivate_eq() -> void:
	AudioServer.set_bus_effect_enabled(bgm_idx, 0, false)
