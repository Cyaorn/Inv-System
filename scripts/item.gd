class_name Item

var name : String
var effect : String
var type : String
var spaces : Array

func _to_string() -> String:
	return "Name: " + str(name) + \
		   "\nEffect: " + str(effect) + \
		   "\nType: " + str(type) + \
		   "\nSpaces: " + str(spaces) + "\n"
