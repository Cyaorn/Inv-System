extends Control

@onready var slot_scene = preload("res://scenes/slot.tscn")
@onready var grid_container = $Background/SkillPalette/GridContainer

# grid data
var ROWS : int = 4
var COLS : int = 4
var grid_array := []

func _ready() -> void:
	grid_container.columns = COLS
	for i in range(ROWS * COLS):
		create_slot()
	
func create_slot() -> void:
	var new_slot = slot_scene.instantiate()
	new_slot.slot_id = grid_array.size()
	grid_container.add_child(new_slot)
	
