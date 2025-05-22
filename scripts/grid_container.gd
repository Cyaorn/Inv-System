extends GridContainer

func _ready() -> void:
	pass
	
func update_slots(cur_pos : Vector2i, item_id : int, item : Item) -> void:
	var slots := []
	# print("Spaces: " + str(item.spaces))
	for i in item.spaces:
		var slot = _vector_to_child(cur_pos + i)
		# print("Adding to slot " + str(slot))
		slot.item_id = item_id
		slots.append(slot.slot_id)
	PlayerData.item_dict.set(item_id, slots)
	
func reset_slots(slot_ids : Array) -> void:
	for slot_id in slot_ids:
		get_child(slot_id + 1).item_id = -1

# add 1 to skip over the Active Layer child
func _vector_to_child(vec : Vector2i) -> Node:
	# print("Child No. " + str(vec.y * PlayerData.COLS + vec.x + 1))
	return get_child(vec.y * PlayerData.COLS + vec.x + 1)
	
func report_name(cur_pos : Vector2i) -> void:
	var slot = _vector_to_child(cur_pos)
	var _name = ""
	if slot.item_id > 0:
		_name = DataLoader.item_data[slot.item_id].name
	$Active/Cursor.update_tooltip(_name, slot.item_id)
