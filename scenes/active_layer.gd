extends TileMapLayer

@onready var item_data = DataLoader.item_data
var tile_id = 0

# active piece variables
var cur_pos : Vector2i
var current_item : Item
var current_piece : int
var current_atlas : Vector2i

func _ready() -> void:
	_reset_piece_variables(0)
	draw_piece()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_w"):
		move_piece(Vector2i.UP)
	elif Input.is_action_just_pressed("ui_a"):
		move_piece(Vector2i.LEFT)
	elif Input.is_action_just_pressed("ui_s"):
		move_piece(Vector2i.DOWN)
	elif Input.is_action_just_pressed("ui_d"):
		move_piece(Vector2i.RIGHT)
	
func _reset_piece_variables(id) -> void:
	cur_pos = Vector2i(0, 0)
	current_piece = id
	current_item = item_data[current_piece]
	current_atlas = Vector2i(DataLoader.skill_type_map.find(current_item.type), 0)
	
func update_piece(item_id) -> void:
	clear_piece()
	_reset_piece_variables(item_id)
	draw_piece()
	
func clear_piece() -> void:
	for i in current_item.spaces:
		erase_cell(cur_pos + i)
	
func draw_piece() -> void:
	for i in current_item.spaces:
		set_cell(cur_pos + i, tile_id, current_atlas)

# similar to Tetris implementation but simply checking if piece is within 4x4
func _can_move(dir):
	for i in current_item.spaces:
		var new_pos = i + cur_pos + dir
		if new_pos.x < 0 or new_pos.x >= DataLoader.COLS or \
		   new_pos.y < 0 or new_pos.y >= DataLoader.COLS:
			return false
	return true
		
func move_piece(dir):
	if _can_move(dir):
		clear_piece()
		cur_pos += dir
		draw_piece()
