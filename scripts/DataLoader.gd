extends Node

# signal item_data_loaded
signal weapon_data_loaded

# maps skill type to corresponding tile in atlas
const skill_type_map := ["Stat", null, null, null, "Other", null, "Command", "Etched"]

# item data
var item_data := {} # might want to use a regular array if the ids are integers
@onready var item_data_path = "res://data/ItemData.json"

# weapon data
var weapon_data := {}
@onready var weapon_data_path = "res://data/WeaponData.json"

func _ready() -> void:
	connect("weapon_data_loaded", PlayerData.initialize_weapon)
	connect("weapon_data_loaded", _announce_load)
	load_item_data(item_data_path)
	load_weapon_data(weapon_data_path)
	set_grid_data()
	
func _announce_load():
	print("Weapon data loaded!")
	
func load_item_data(path) -> void:
	if not FileAccess.file_exists(path):
		print("Item data file not found")
		return
	var data_file = FileAccess.open(path, FileAccess.READ)
	var raw_item_data = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	# print(item_data)
	var temp_item_data = {}
	for key in raw_item_data.keys():
		var temp_item : Item = Item.new()
		var temp_size : String
		var temp_array := []
		temp_item.id = int(key)
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
	# print(item_data)

func load_weapon_data(path) -> void:
	if not FileAccess.file_exists(path):
		print("Weapon data file not found")
		return
	var data_file = FileAccess.open(path, FileAccess.READ)
	var raw_data = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	
	var temp_data = {}
	for key in raw_data.keys():
		var temp_weapon := Weapon.new()
		temp_weapon.id = int(key)
		temp_weapon.name = raw_data[key]["Name"]
		temp_weapon.width = raw_data[key]["Width"]
		temp_weapon.height = raw_data[key]["Height"]
		temp_weapon.power = raw_data[key]["Power"]
		temp_weapon.secret_name = raw_data[key]["SecretName"]
		temp_weapon.secret_effect = raw_data[key]["SecretEffect"]
		temp_weapon.embedded = {}
		
		if raw_data[key]["Embedded"] == null or \
		   raw_data[key]["Embedded"] == "":
			temp_data.set(int(key), temp_weapon)
			continue
		var embedded = raw_data[key]["Embedded"].split("/")
		for embed in embedded:
			var split = embed.split(";")
			var item_id = split[0]
			var coords = split[1].split(",")
			coords = Vector2i(int(coords[0]), int(coords[1]))
			temp_weapon.embedded.set(item_id, coords)
		temp_data.set(int(key), temp_weapon)
	weapon_data = temp_data
	# print(weapon_data)
	emit_signal("weapon_data_loaded")

func set_grid_data() -> void:
	pass

func _child_to_vector(slot_id : int) -> Vector2i:
	return Vector2i(slot_id % PlayerData.COLS, int(slot_id / PlayerData.COLS))
