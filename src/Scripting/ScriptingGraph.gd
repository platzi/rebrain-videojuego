extends GraphEdit

func _ready():
	# CONNECTIONS
	connect("connection_request", self, "_on_connection_request")
	connect("disconnection_request", self, "_on_disconnection_request")

func _on_connection_request(from : String, fromSlot : int, to : String, toSlot : int) -> void:
	connect_node(from, fromSlot, to, toSlot)

func _on_disconnection_request(from : String, fromSlot : int, to : String, toSlot : int) -> void:
	disconnect_node(from, fromSlot, to, toSlot)
