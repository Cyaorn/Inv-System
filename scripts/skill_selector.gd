extends OptionButton

signal report_id

@onready var item_data = DataLoader.item_data

# keep track of the current item via its item_data id
var current_item : int

func _ready() -> void:
	add_item("None", 0)
	for key in item_data.keys():
		# print(item_data[key].name, key)
		add_item(item_data[key].name, key)
	# print("SkillSelector ready!")
		
func report_selected(idx) -> void:
	emit_signal("report_id", get_item_id(idx))

func reset_selection() -> void:
	selected = 0
	
	
func remove_selection(id) -> void:
	# print("Disabling piece")
	set_item_disabled(get_item_index(id), true)

func _remove_selection(_cur_pos, id, _item) -> void:
	remove_selection(id)
	reset_selection()

func add_selection(item_id: int) -> void:
	var idx = get_item_index(item_id)
	set_item_disabled(idx, false)
	print(is_item_disabled(idx))
	selected = idx


func _on_active_piece_too_large(id) -> void:
	remove_selection(id)
