extends Node

var _register: Dictionary[String, Item] = {}

func entry(item_name: String) -> Item:
	return _register.get(item_name) as Item

func keys() -> Array[String]:
	return _register.keys()
	
func values() -> Array[Item]:
	return _register.values()

func register(name: String, item: Item) -> void:
	_register.set(name, item)

func is_registered(name: String) -> bool:
	return _register.has(name)

func remove(name: String) -> void:
	_register.erase(name)
	
func size() -> int:
	return _register.size()
