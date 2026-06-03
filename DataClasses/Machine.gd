extends RefCounted
class_name Machine

var name: String

func _init(name) -> void:
	self.name = name
	
func _to_string() -> String:
	return """Machine {name} {\n\tname: {name}\n}""".format({ "name": self.name })
