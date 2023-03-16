extends EventCustom


func execute() -> void:
	SaveManager.complete_level("Epilogue")
	SceneChanger.change_scene("res://src/Menu/LevelSelectionMenu.tscn")
