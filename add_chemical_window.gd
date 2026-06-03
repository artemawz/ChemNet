extends Window

signal chemical_added(chemical: Chemical)

func _on_name_input_text_changed(new_name: String) -> void:
	if not new_name.is_valid_ascii_identifier():
		disallow("Name must only contain underscores, numbers and letters.\nThe first character cannot be a number.\nName cannot be empty.")
		return
		
	if ChemicalRegister.is_registered(new_name):
		disallow("Chemical already exists")
		return
		
	allow()


func back_to_default() -> void:
	%NameInput.text = ""
	%State.select(0)
	disallow("")


func _on_close_requested() -> void:
	back_to_default()
	hide()
	
	
func _ready() -> void:
	back_to_default()
	
	
func allow():
	%Add.disabled = false
	%Warning.text = ""
	
	
func disallow(reason: String):
	%Add.disabled = true
	%Warning.text = reason


func _on_add_pressed() -> void:
	add_chemical()
	hide()
	back_to_default()
	

func _on_cancel_pressed() -> void:
	back_to_default()
	hide()


func add_chemical() -> Chemical:
	var chemical_name = %NameInput.text
	var chemical = ChemicalRegister.entry(chemical_name)
	
	if not chemical_name.is_valid_ascii_identifier():
		disallow("Name must only contain underscores, numbers and letters.\nThe first character cannot be a number.\nName cannot be empty.")
		return null
		
	if chemical:
		disallow("Chemical already exists")
		return null
	
	chemical = Chemical.new(
		chemical_name,
		get_chemical_state()
	)
	ChemicalRegister.register(
		chemical_name,
		chemical
	)
	chemical_added.emit(chemical)
	return chemical
	
	
func get_chemical_state() -> Chemical.State:
	var selected = %State.get_item_text(%State.selected).strip_edges(true, true).to_lower()
	match selected:
		"solid": return Chemical.State.SOLID
		"liquid": return Chemical.State.LIQUID
		"gas": return Chemical.State.GAS
	
	return Chemical.State.SOLID


func _on_about_to_popup() -> void:
	%NameInput.grab_focus()
