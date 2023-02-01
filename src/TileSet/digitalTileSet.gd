tool

extends TileSet


const PERMITED = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]


func _is_tile_bound(drawn_id : int, neighbor_id : int) -> bool:
	if drawn_id in PERMITED:
		return neighbor_id in PERMITED
	return false
