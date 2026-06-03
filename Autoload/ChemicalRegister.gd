extends Node

var _register: Dictionary[String, Chemical] = {}

func entry(chemical_name: String) -> Chemical:
	return _register.get(chemical_name) as Chemical

func keys() -> Array[String]:
	return _register.keys()
	
func values() -> Array[Chemical]:
	return _register.values()

func register(name: String, chemical: Chemical) -> void:
	_register.set(name, chemical)

func is_registered(name: String) -> bool:
	return _register.has(name)

func remove(name: String) -> void:
	_register.erase(name)
