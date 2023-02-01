extends Control


enum PROPERTY_TYPE {
	HAIR
}


export(Array, Texture) var hair_textures
export(NodePath) var hair_hbc_path


onready var hair_hbc : HBoxContainer = get_node(hair_hbc_path)

func _ready():
	$PlayerAP.play("Rotate")
	
	hair_hbc.get_node("PropertyNextBtn").connect("pressed", self, "_on_property_prev_btn_pressed", [hair_hbc, PROPERTY_TYPE.HAIR])


func _on_property_prev_btn_pressed(hbc, type) -> void:
	var label : Label = hbc.get_node("PropertyLabel")
	match type:
		PROPERTY_TYPE.HAIR:
			label.text = "HELLO"
