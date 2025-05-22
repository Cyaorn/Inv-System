extends Control

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var skill_selector = $SkillSelector
@onready var active_layer = $SkillPalette/GridContainer/Active
@onready var grid_container = $SkillPalette/GridContainer
@onready var cursor = $SkillPalette/GridContainer/Active/Cursor

# grid data
var grid_array := []
var current_weapon : int = PlayerData.current_weapon

func _ready() -> void:
	# should probably put these signals in another autoload function
	skill_selector.connect("item_selected", skill_selector.report_selected)
	skill_selector.connect("report_id", active_layer.update_piece)
	active_layer.connect("reset_selection", skill_selector.reset_selection)
	active_layer.connect("piece_too_large", skill_selector.remove_selection)
	active_layer.connect("piece_placed", skill_selector._remove_selection)
	active_layer.connect("piece_placed", grid_container.update_slots)
	active_layer.connect("piece_removed_from_board", grid_container.reset_slots)
	active_layer.connect("piece_lifted", skill_selector.add_selection)
	active_layer.connect("cursor_hovering", grid_container.report_name)
	reset_grid()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_down"):
		print(grid_array)
		print(PlayerData.item_dict)
	
func reset_grid() -> void:
	# delete old slot nodes
	for slot in grid_array:
		grid_container.remove_child(slot)
		slot.queue_free()
	
	# Recreate new grid
	grid_array = []
	grid_container.columns = PlayerData.COLS
	for i in range(PlayerData.ROWS * PlayerData.COLS):
		create_slot()
	# print(grid_array)
		
func create_slot() -> void:
	var new_slot = slot_scene.instantiate()
	new_slot.slot_id = grid_array.size()
	grid_array.append(new_slot)
	grid_container.add_child(new_slot)
