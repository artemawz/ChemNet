extends Node

var _register: Dictionary[String, Machine] = {}

func entry(machine_name: String) -> Machine:
	return _register.get(machine_name) as Machine

func keys() -> Array[String]:
	return _register.keys()
	
func values() -> Array[Machine]:
	return _register.values()

func register(name: String, machine: Machine) -> void:
	_register.set(name, machine)

func is_registered(name: String) -> bool:
	return _register.has(name)

func remove(name: String) -> void:
	_register.erase(name)
