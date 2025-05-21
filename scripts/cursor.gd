extends TextureRect

@onready var container = $Container
@onready var tooltip = $Container/Margin/Tooltip
@onready var rect = $Container/ColorRect

var current_item_id : int

func _ready() -> void:
	tooltip.text = ""
	container.hide()

func update_tooltip(_str : String, item_id : int) -> void:
	current_item_id = item_id
	tooltip.text = _str
	if _str == "":
		container.hide()
	else:
		container.show()
