extends TileMapLayer

signal cursor_hovering
signal piece_placed

@onready var board = $Board
@onready var cursor = $Cursor
@onready var item_data = DataLoader.item_data
const tile_id = 0
const TILE_SIZE := 100
const TRANSLUCENT := Color(1, 1, 1, 0.4)
const ERROR_COLOR := Color(1, 0, 0, 1)

# active piece variables
var piece_selected : bool = false
var cur_pos : Vector2i
var current_item : Item
var current_id : int
var current_atlas : Vector2i

func _ready() -> void:
	# connect("cursor_hovering", cursor.update_tooltip)
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
	elif Input.is_action_just_pressed("ui_f"):
		if piece_selected:
			clear_piece()
			place_piece()
	
	if Input.is_action_just_pressed("ui_up"):
		_reset_piece()

func _reset_piece_variables(id) -> void:
	_reset_cursor()
	current_id = id
	self_modulate = TRANSLUCENT
	if id == 0:
		cursor.show()
		piece_selected = false
	else:
		cursor.hide()
		piece_selected = true
		current_item = item_data[current_id]
		current_atlas = Vector2i(DataLoader.skill_type_map.find(current_item.type), 0)
	
func _reset_cursor():
	cur_pos = Vector2i(0, 0)
	cursor.position = Vector2(0, 0)
	
func _reset_piece():
	print("Resetting piece")
	print("Color: " + str(self_modulate))
	clear_piece()
	draw_piece()
	
# runs whenever a new option is selected in dropdown
func update_piece(item_id) -> void:
	# if previous selected piece was None
	if current_id != 0:
		clear_piece()
	_reset_piece_variables(item_id)
	draw_piece()
	
func clear_piece() -> void:
	for i in current_item.spaces:
		erase_cell(cur_pos + i)
	
func draw_piece(error : bool = false) -> void:
	# self_modulate = TRANSLUCENT
	for i in current_item.spaces:
		set_cell(cur_pos + i, tile_id, (current_atlas if not error else Vector2i(1, 0)))

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
		
func move_piece(_dir) -> void:
	if piece_selected: # can_move logic offloaded to move_cursor function
		# clear_piece()
		# cur_pos += dir
		draw_piece()

func _can_place() -> bool:
	for i in current_item.spaces:
		if not board.is_free(i + cur_pos):
			print("Cannot place!")
			return false
	return true
	
func place_piece() -> void:
	if _can_place():
		for i in current_item.spaces:
			erase_cell(cur_pos + i)
			board.set_cell(cur_pos + i, tile_id, current_atlas)
		emit_signal("piece_placed", cur_pos, current_id, current_item)
		emit_signal("cursor_hovering", cur_pos)
		_reset_piece_variables(0)
	else:
		clear_piece()
		draw_piece(true)
		var tween = create_tween()
		tween.tween_method(_set_color, ERROR_COLOR, TRANSLUCENT, 0.4)
		tween.connect("finished", _reset_piece)
		
func _set_color(color: Color):
	self_modulate = color

func move_cursor(dir) -> void:
	var moveable := false
	moveable = _can_move(dir) if piece_selected else _can_move_cursor(dir)
	if moveable:
		if piece_selected:
			clear_piece()
		cur_pos += dir
		cursor.position = Vector2(cur_pos * TILE_SIZE)
		if not piece_selected:
			# print("Emitting cursor_hovering")
			emit_signal("cursor_hovering", cur_pos)
