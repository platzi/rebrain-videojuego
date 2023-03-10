tool


extends PopupPanel


signal node_selected


onready var node_list_vbc := $VBoxContainer/NodeListSC/NodeListVBC


var nodes_limit := {} setget _set_nodes_limit

func _ready():
	_create_buttons()


func _clear_buttons() -> void:
	for child in node_list_vbc.get_children():
		child.visible = false
		child.queue_free()


func _create_buttons() -> void:
	_clear_buttons()
	for group in NodesList.NODES:
		var added_count := 0
		var group_button := Label.new()
		group_button.align = Label.ALIGN_LEFT
		group_button.text = group
		node_list_vbc.add_child(group_button)
		for node in NodesList.NODES[group]:
			var node_type : String = node[0]
			var node_name : String = node[1]
			var node_image : StreamTexture = node[2]
			if Engine.editor_hint:
				nodes_limit[node_type] = round(rand_range(1.0, 3.0))
			if nodes_limit.has(node_type):
				var button := Button.new()
				button.align = Button.ALIGN_LEFT
				button.text = node_name + ((" (%s)" % nodes_limit[node_type]) if nodes_limit[node_type] >= 0 else "")
				button.icon = node_image if node_image else null
				button.disabled = true if nodes_limit[node_type] == 0 else false
				button.connect("pressed", self, "_on_node_button_pressed", [node[0]])
				button.expand_icon = true
				button.focus_mode = Control.FOCUS_NONE
				node_list_vbc.add_child(button)
				added_count += 1
		if added_count == 0:
			group_button.visible = false


func _on_node_button_pressed(node_type : String) -> void:
	emit_signal("node_selected", node_type)


func _set_nodes_limit(new_value : Dictionary) -> void:
	nodes_limit = new_value
	_create_buttons()

