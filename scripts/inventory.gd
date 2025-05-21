extends Control

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var skill_selector = $SkillSelector
@onready var active_layer = $SkillPalette/GridContainer/Active
@onready var grid_container = $SkillPalette/GridContainer
@onready var cursor = $SkillPalette/GridContainer/Active/Cursor

# grid data
var ROWS : int = 4
var COLS : int = 4
var grid_array := []

func _ready() -> void:
	skill_selector.connect("item_selected", skill_selector.report_selected)
	skill_selector.connect("report_id", active_layer.update_piece)
	active_layer.connect("reset_selection", skill_selector.reset_selection)
	active_layer.connect("piece_placed", skill_selector.remove_selection)
	active_layer.connect("piece_placed", grid_container.update_slots)
	active_layer.connect("piece_removed_from_board", grid_container.reset_slots)
	active_layer.connect("piece_lifted", skill_selector.add_selection)
	# probably a more efficient way than to go signal -> signal to report data
	active_layer.connect("cursor_hovering", grid_container.report_name)
	grid_container.connect("reporting_tooltip", cursor.update_tooltip)
	# -----------------------------------------------------------------------
	grid_container.columns = COLS
	for i in range(ROWS * COLS):
		create_slot()
	
func create_slot() -> void:
	var new_slot = slot_scene.instantiate()
	new_slot.slot_id = grid_array.size()
	grid_array.append(new_slot)
	grid_container.add_child(new_slot)
	
