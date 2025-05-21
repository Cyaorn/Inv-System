extends TextureRect

@onready var container = $Container
@onready var tooltip = $Container/Margin/Tooltip
@onready var rect = $Container/ColorRect

func _ready() -> void:
	tooltip.text = ""
	container.hide()

func update_tooltip(_str : String) -> void:
	# not sure how to hide the entire node tree 
	tooltip.text = _str
	if _str == "":
		container.hide()
	else:
		container.show()
