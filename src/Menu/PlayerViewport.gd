extends Viewport


const HAIR_STYLES = [
	preload("res://assets/images/backgrounds/main-menu-player-hair-02.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-01.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-03.png"),
	preload("res://assets/images/backgrounds/main-menu-player-hair-04.png"),
	null
]


func _ready() -> void:
	_load_avatar()


func _load_avatar() -> void:
	player_hair_tr.texture = HAIR_STYLES[SaveManager.save_data["customization"]["hair_style"]]
	player_hair_tr.material.set_shader_param("HAIR_COLOR", Customization.HAIR_COLORS[SaveManager.save_data["customization"]["hair_color"]])
	player_tr.material.set_shader_param("SKIN_COLOR", Customization.SKIN_COLORS[SaveManager.save_data["customization"]["skin_color"]])
	player_tr.material.set_shader_param("SHIRT_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["shirt_color"]])
	player_tr.material.set_shader_param("PANTS_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["pants_color"]])
	player_tr.material.set_shader_param("SHOES_COLOR", Customization.CLOTHES_COLOR[SaveManager.save_data["customization"]["shoes_color"]])
