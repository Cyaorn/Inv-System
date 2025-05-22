extends Node

# stores all the items where 
# 	key: item_id, value: array of slots occupied by item
# eventually:
#	key: weapon_id, value: array of (item_id, [slot_id], stuck?) tuples
#	[stuck?] will determine if the skill piece is permanently attached to weap.
var item_dict := {}

var current_weapon := 1
var ROWS : int
var COLS : int 

func initialize_weapon():
	ROWS = DataLoader.weapon_data[current_weapon].height
	COLS = DataLoader.weapon_data[current_weapon].width
