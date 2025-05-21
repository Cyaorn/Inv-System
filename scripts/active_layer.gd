extends TileMapLayer

@onready var board = $Board
@onready var cursor = $Cursor
@onready var item_data = DataLoader.item_data
const tile_id = 0
const TILE_SIZE := 100

# active piece variables
var piece_selected : bool = false
var cur_pos : Vector2i
var current_item : Item
var current_piece : int
var current_atlas : Vector2i

func _ready() -> void:
	_reset_piece_variables(0)
	# draw_piece()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_w"):
		move_cursor(Vector2i.UP)
		move_piece(Vector2i.UP)
	elif Input.is_action_just_pressed("ui_a"):
		move_cursor(Vector2i.LEFT)
		move_piece(Vector2i.LEFT)
	elif Input.is_action_just_pressed("ui_s"):
		move_cursor(Vector2i.DOWN)
		move_piece(Vector2i.DOWN)
	elif Input.is_action_just_pressed("ui_d"):
		move_cursor(Vector2i.RIGHT)
		move_piece(Vector2i.RIGHT)
	
func _reset_piece_variables(id) -> void:
	cur_pos = Vector2i(0, 0)
	current_piece = id
	if id == 0:
		cursor.show()
		piece_selected = false
	else:
		cursor.hide()
		piece_selected = true
		current_item = item_data[current_piece]
		current_atlas = Vector2i(DataLoader.skill_type_map.find(current_item.type), 0)
	
# runs whenever a new option is selected in dropdown
func update_piece(item_id) -> void:
	# if previous selected piece was None
	if current_piece != 0:
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
func _can_move(dir) -> bool:
	if not piece_selected:
		return false
	for i in current_item.spaces:
		var new_pos = i + cur_pos + dir
		if new_pos.x < 0 or new_pos.x >= DataLoader.COLS or \
		   new_pos.y < 0 or new_pos.y >= DataLoader.ROWS:
			return false
	return true

func _can_move_cursor(dir) -> bool:
	var new_pos = dir + cur_pos 
	return new_pos.x >= 0 and new_pos.x < DataLoader.COLS and \
		   new_pos.y >= 0 and new_pos.y < DataLoader.ROWS
		
func move_piece(dir) -> void:
	if piece_selected: # can_move logic offloaded to move_cursor function
		# clear_piece()
		# cur_pos += dir
		draw_piece()

func _can_place() -> bool:
	for i in current_item.spaces:
		if not board.is_free(i + cur_pos):
			return false
	return true
	
func place_piece() -> void:
	for i in current_item.spaces:
		erase_cell(cur_pos + i)
		
func move_cursor(dir) -> void:
	var moveable := false
	moveable = _can_move(dir) if piece_selected else _can_move_cursor(dir)
	if moveable:
		if piece_selected:
			clear_piece()
		cur_pos += dir
		cursor.position = Vector2(cur_pos * TILE_SIZE)
		# print(cursor.position)
