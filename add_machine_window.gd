extends Window

signal machine_added(machine: Machine)


func _on_name_input_text_changed(new_name: String) -> void:
	if not new_name.is_valid_ascii_identifier():
		disallow("Name must only contain underscores, numbers and letters.\nThe first character cannot be a number.\nName cannot be empty.")
		return
		
	if MachineRegister.is_registered(new_name):
		disallow("Machine already exists")
		return
		
	allow()


func _on_cancel_pressed() -> void:
	back_to_default()
	hide()


func _on_add_pressed() -> void:
	add_machine()
	hide()
	back_to_default()


func _on_close_requested() -> void:
	back_to_default()
	hide()


func back_to_default() -> void:
	%Add.disabled = true
	%NameInput.clear()
	%Warning.text = ""
	
	
func _ready() -> void:
	pass


func allow():
	%Add.disabled = false
	%Warning.text = ""
	
	
func disallow(reason: String):
	%Add.disabled = true
	%Warning.text = reason
	
	
func add_machine() -> Machine:
	var machine_name = %NameInput.text
	var machine = MachineRegister.entry(machine_name)
	
	if not machine_name.is_valid_ascii_identifier():
		disallow("Name must only contain underscores, numbers and letters.\nThe first character cannot be a number.\nName cannot be empty.")
		return null
		
	if machine:
		disallow("Machine already exists")
		return null
	
	machine = Machine.new(machine_name)
	MachineRegister.register(
		machine_name,
		machine
	)
	machine_added.emit(machine)
	return machine


func _on_about_to_popup() -> void:
	%NameInput.grab_focus()
