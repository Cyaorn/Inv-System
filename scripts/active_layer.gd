extends TileMapLayer

signal cursor_hovering
signal reset_selection
signal piece_placed
signal piece_removed_from_board
signal piece_lifted
signal piece_too_large

@onready var board = $Board
@onready var cursor = $Cursor
@onready var item_data = DataLoader.item_data
@onready var item_dict = PlayerData.item_dict
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
	_reset_piece_variables(0, true)
	fix_selections()
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
		# place piece if selected
		if piece_selected:
			clear_piece()
			place_piece()
		# else, pick up any piece the cursor is hovering over
		else:
			pick_up_piece()
	elif Input.is_action_just_pressed("ui_x"):
		if piece_selected:
			clear_piece()
			_reset_piece_variables(0)
			emit_signal("cursor_hovering", cur_pos)
			emit_signal("reset_selection")
	
	if Input.is_action_just_pressed("ui_up"):
		_reset_piece()

func _reset_piece_variables(id, full_reset : bool = false) -> void:
	if full_reset:
		emit_signal("reset_selection")
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
	emit_signal("cursor_hovering", cur_pos)
	
func _reset_piece():
	# print("Resetting piece")
	# print("Color: " + str(self_modulate))
	clear_piece()
	draw_piece()
	
# Pretty inefficient function since it checks through every single possible
#   square in every piece, but it should only run whenever the player equips
#   a different weapon
func fix_selections():
	for key in item_data.keys():
		# print("Item: " + item_data[key].name)
		for coord in item_data[key].spaces:
			# print(coord)
			if coord.x >= PlayerData.COLS or coord.y >= PlayerData.ROWS:
				print("Piece too big: " + item_data[key].name, key)
				emit_signal("piece_too_large", key)
	
# runs whenever a new option is selected in dropdown
func update_piece(item_id) -> void:
	# if previous selected piece was not None, clear it
	if current_id != 0:
		clear_piece()
	_reset_cursor()
	_reset_piece_variables(item_id)
	
	# if current piece is not None, draw it
	if item_id != 0:
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
		if new_pos.x < 0 or new_pos.x >= PlayerData.COLS or \
		   new_pos.y < 0 or new_pos.y >= PlayerData.ROWS:
			return false
	return true

func _can_move_cursor(dir) -> bool:
	var new_pos = dir + cur_pos 
	return new_pos.x >= 0 and new_pos.x < PlayerData.COLS and \
		   new_pos.y >= 0 and new_pos.y < PlayerData.ROWS
		
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
		emit_signal("reset_selection")
		emit_signal("cursor_hovering", cur_pos)
		_reset_piece_variables(0)
		print(item_dict)
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

# uses global item_dict to figure out where the entire piece is
func pick_up_piece() -> void:
	var hover_id = cursor.current_item_id
	if hover_id == -1:
		return
	
	# erase cells from Board Layer
	for i in item_dict[hover_id]:
		board.erase_cell(DataLoader._child_to_vector(i))
		# print("Erasing cell " + str(DataLoader._child_to_vector(i)))
	
	# reset item_id of slots
	emit_signal("piece_removed_from_board", item_dict[hover_id])
	
	# add piece back to dropdown menu
	emit_signal("piece_lifted", hover_id)
	
	# remove piece from item_dict
	item_dict.erase(hover_id)
	
	# set hovered piece to current held piece
	piece_selected = true
	_reset_piece_variables(hover_id)
	draw_piece()
	
