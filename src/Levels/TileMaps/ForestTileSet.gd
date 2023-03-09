tool


extends TileSet


const GRASS := 0
const WATER := 1
const DIRT := 2


const BINDS : Dictionary = {
	GRASS : [DIRT]
}


func _is_tile_bound(drawn_id : int, neighbor_id : int) -> bool:
	if drawn_id in BINDS:
		return neighbor_id in BINDS[drawn_id]
	return false
