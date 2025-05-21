extends OptionButton

@onready var item_data = DataLoader.item_data

# keep track of the current item via its item_data id
var current_item : int

func _ready() -> void:
	add_item("None")
	for key in item_data.keys():
		add_item(item_data[key].name, key)
	
