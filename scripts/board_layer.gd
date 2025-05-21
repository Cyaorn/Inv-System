extends TileMapLayer

func _ready() -> void:
	pass
	
func is_free(pos):
	return get_cell_source_id(pos) == -1
