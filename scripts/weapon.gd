class_name Weapon

var id : int
var name : String
var height : int
var width : int
var power : int
var secret_name : String
var secret_effect : String

# embedded will store key: item_id, value: Vector2i pairs
var embedded : Dictionary

func _to_string() -> String:
	return "Id: " + str(id) + \
		   "\nName: " + str(name) + \
		   "\nDimensions: " + str(width) + ", " + str(height) + \
		   "\nPower: " + str(power) + \
		   "\nSecret: " + str(secret_name) + \
		   "\nEffect: " + str(secret_effect) + \
		   "\nEmbedded: " + str(embedded) + "\n"
