extends RefCounted
class_name Chemical

var state: State
var name: String

enum State {
	SOLID,
	LIQUID,
	GAS
}

func display_state(state: State) -> String:
	match state:
		State.SOLID: return "Chemical.State.SOLID"
		State.LIQUID: return "Chemical.State.LIQUID"
		_: return "Chemical.State.GAS"

func _init(name: String, state: State) -> void:
	self.name = name
	self.state = state

func _to_string() -> String:
	return """Chemical {chemical_name} {
		chemical_name: {chemical_name},
		state: {state}\n}""".format({
		"name": name,
		"state": display_state(state)
	})
