extends TextureRect

var slot_id : int
var item_id : int = -1

func _to_string() -> String:
	return "Slot ID: " + str(slot_id) + ", Item_ID: " + str(item_id)
