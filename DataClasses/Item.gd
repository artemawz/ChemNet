extends RefCounted
class_name Item

var name: String

func _init(name: String) -> void:
	self.name = name
	
func _to_string() -> String:
	return "Item %s { name: %s }" % [self.name, self.name]
