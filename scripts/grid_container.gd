extends GridContainer

signal reporting_tooltip

const ROWS := DataLoader.ROWS
const COLS := DataLoader.COLS

func _ready() -> void:
	pass
	
func update_slots(cur_pos : Vector2i, item_id : int, item : Item) -> void:
	var slots := []
	for i in item.spaces:
		var slot = _vector_to_child(cur_pos + i)
		slot.item_id = item_id
		slots.append(slot.slot_id)
	DataLoader.item_dict.set(item_id, slots)
	
func reset_slots(slot_ids : Array) -> void:
	for slot_id in slot_ids:
		get_child(slot_id + 1).item_id = -1

# add 1 to skip over the Active Layer child
func _vector_to_child(vec : Vector2i) -> Node:
	return get_child(vec.y * COLS + vec.x + 1)
	
func report_name(cur_pos : Vector2i) -> void:
	var slot = _vector_to_child(cur_pos)
	var _name = ""
	if slot.item_id > 0:
		_name = DataLoader.item_data[slot.item_id].name
	# print("Emitting reporting_tooltip: " + str(_name))
	emit_signal("reporting_tooltip", _name, slot.item_id)
