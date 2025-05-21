class_name Item

var id : int
var name : String
var effect : String
var type : String
var spaces : Array

func _to_string() -> String:
	return "Id: " + str(id) + \
		   "\nName: " + str(name) + \
		   "\nEffect: " + str(effect) + \
		   "\nType: " + str(type) + \
		   "\nSpaces: " + str(spaces) + "\n"
