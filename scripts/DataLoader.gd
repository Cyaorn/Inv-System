extends Node

# maps skill type to corresponding tile in atlas
const skill_type_map := ["Stat", null, null, null, null, null, null, "Other"]
# these are subject to change later
const ROWS := 4
const COLS := 4

# item data
var item_data := {}
var item_grid_data := {}
@onready var item_data_path = "res://data/ItemData.json"


func _ready() -> void:
	load_data(item_data_path)
	set_grid_data()
	
func load_data(path) -> void:
	if not FileAccess.file_exists(path):
		print("Item data file not found")
		return
	var item_data_file = FileAccess.open(path, FileAccess.READ)
	var raw_item_data = JSON.parse_string(item_data_file.get_as_text())
	item_data_file.close()
	# print(item_data)
	var temp_item_data = {}
	for key in raw_item_data.keys():
		var temp_item : Item = Item.new()
		var temp_size : String
		var temp_array := []
		temp_item.name = raw_item_data[key]["Name"]
		temp_item.effect = raw_item_data[key]["Effect"]
		temp_item.type = raw_item_data[key]["Type"]
		temp_size = raw_item_data[key]["Size"]
		for coord in temp_size.split("/"):
			var coords = coord.split(",")
			temp_array.append(Vector2i(int(coords[0]), int(coords[1])))
		temp_item.spaces = temp_array
		temp_item_data.set(int(key), temp_item)
	item_data = temp_item_data
	print(item_data)

func set_grid_data() -> void:
	pass
