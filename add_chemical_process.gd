extends Window

var selected_input: int = -1
var selected_output: int = -1
var selected_chemical: Chemical = null
var selected_chemical_idx: int = -1
var selected_machine: Machine = null
var selected_machine_idx: int = -1

func _on_add_machine_pressed() -> void:
	%AddMachineWindow.popup()

func _on_include_temp_requirement_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%TempRequirement.editable = true
	else:
		%TempRequirement.editable = false
		
func _on_include_pressure_requirement_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%PressureRequirement.editable = true
	else:
		%PressureRequirement.editable = false

func _on_add_input_element_pressed() -> void:
	pass # Replace with function body.


func _on_remove_selected_input_element_pressed() -> void:
	if selected_input == -1:
		printerr("Somehow 'selected_input' is -1 even though this should not be possible at this point.")
		return
	
	%Inputs.remove_item(selected_input)
	var selected = %Inputs.get_selected_items()
	selected_input = selected[0] if selected else -1


func _on_add_output_element_pressed() -> void:
	pass # Replace with function body.


func _on_remove_selected_output_element_pressed() -> void:
	if selected_output == -1:
		printerr("Somehow 'selected_output' is -1 even though this should not be possible at this point.")
		return
	
	%Outputs.remove_item(selected_output)
	var selected = %Outputs.get_selected_items()
	selected_output = selected[0] if selected else -1

func _on_inputs_item_selected(index: int) -> void:
	selected_input = index
	%RemoveSelectedInputElement.disabled = false


func _on_outputs_item_selected(index: int) -> void:
	selected_output = index
	%RemoveSelectedOutputElement.disabled = false


func _on_outputs_focus_exited() -> void:
	selected_output = -1
	%RemoveSelectedOutputElement.disabled = true


func _on_inputs_focus_exited() -> void:
	selected_input = -1
	%RemoveSelectedInputElement.disabled = true


func _on_close_requested() -> void:
	%ConfirmCancellation.popup()
	
func back_to_defaults() -> void:
	%ChemicalSelection.select(-1)
	%RemoveSelectedChemical.disabled = true
	%MachineSelection.select(-1)
	%RemoveSelectedMachine.disabled = true
	%IncludeTempRequirement.disabled = true
	%TempRequirement.set_value_no_signal(100)
	%IncludePressureRequirement.disabled = true
	%PressureRequirement.set_value_no_signal(1.0)
	%RemoveSelectedInputElement.disabled = true
	%MainOutputAmount.editable = false
	%MainOutputAmount.value = 0
	%MainOutputAmount.suffix = "Item(s)"
	%RemoveSelectedOutputElement.disabled = true
	%Inputs.clear()
	%Outputs.clear()
	
	selected_input = -1
	selected_output = -1
	selected_chemical = null
	selected_chemical_idx = -1
	selected_machine = null
	selected_machine_idx = -1
	

func _on_chemical_selection_item_selected(index: int) -> void:
	var name = %ChemicalSelection.get_item_text(index)
	var chemical := ChemicalRegister.entry(name) as Chemical
	
	if not chemical:
		printerr("Chemical '{name}' is not a registered chemical (even though it should be because the list was literally made using it???)".format({ "name": name }))
		return
		
	var suffix = "Item(s)" if chemical.state == Chemical.State.SOLID else "mB"  
	
	%MainOutputAmount.suffix = suffix
	%MainOutputAmount.editable = true
	%RemoveSelectedChemical.disabled = false
	
	print("_on_chemical_selection_item_selected: selected_chemical = %s" % chemical)
	print("_on_chemical_selection_item_selected: selected_chemical_idx = %s" % index)
	selected_chemical = chemical
	selected_chemical_idx = index


func _on_add_chemical_pressed() -> void:
	%AddChemicalWindow.popup()


func _on_add_chemical_window_chemical_added(chemical: Chemical) -> void:
	var item_count_before_update = %ChemicalSelection.item_count
	update_chemical_selection_list()
	var idx = maxi(0, selected_chemical_idx)
	%ChemicalSelection.select(idx)
	%ChemicalSelection.item_selected.emit(idx)


func update_chemical_selection_list() -> void:
	%ChemicalSelection.clear()
	for chemical in ChemicalRegister.keys():
		%ChemicalSelection.add_item(chemical)


func update_machine_selection_list() -> void:
	%MachineSelection.clear()
	for machine in MachineRegister.keys():
		%MachineSelection.add_item(machine)


func _on_remove_selected_chemical_pressed() -> void:
	%ConfirmChemicalRemoval.title = "Remove %s?" % selected_chemical.name
	%ConfirmChemicalRemoval.dialog_text = "Do you really want to remove '%s'?" % selected_chemical.name
	%ConfirmChemicalRemoval.popup()


func _on_add_machine_window_machine_added(machine: Machine) -> void:
	var item_count_before_update = %MachineSelection.item_count
	update_machine_selection_list()
	var idx = maxi(0, selected_machine_idx)
	%MachineSelection.select(idx)
	%MachineSelection.item_selected.emit(idx)


func _on_machine_selection_item_selected(index: int) -> void:
	var machine_name = %MachineSelection.get_item_text(index)
	var machine := MachineRegister.entry(machine_name) as Machine
	
	if not machine:
		printerr("Machine '{machine_name}' is not a registered machine (even though it should be because the list was literally made using it???)".format({ "machine_name": machine_name }))
		return
		
	%RemoveSelectedMachine.disabled = false
	
	print("_on_machine_selection_item_selected: selected_machine = %s" % machine)
	print("_on_machine_selection_item_selected: selected_machine_idx = %s" % index)
	selected_machine = machine
	selected_machine_idx = index


func _on_remove_selected_machine_pressed() -> void:
	%ConfirmMachineRemoval.title = "Remove %s?" % selected_machine.name
	%ConfirmMachineRemoval.dialog_text = "Do you really want to remove '%s'?" % selected_machine.name
	%ConfirmMachineRemoval.popup()


func _on_cancel_pressed() -> void:
	hide()
	back_to_defaults()


func _on_add_chemical_window_close_requested() -> void:
	grab_focus()


func _on_add_machine_window_close_requested() -> void:
	grab_focus()


func _on_confirm_chemical_removal_confirmed() -> void:
	ChemicalRegister.remove(selected_chemical.name)
	%ChemicalSelection.remove_item(selected_chemical_idx)
	selected_chemical_idx = -1
	%RemoveSelectedChemical.disabled = true
	%MainOutputAmount.editable = false


func _on_confirm_machine_removal_confirmed() -> void:
	MachineRegister.remove(selected_machine.name)
	%MachineSelection.remove_item(selected_machine_idx)
	selected_machine_idx = -1
	%RemoveSelectedMachine.disabled = true


func _on_confirm_input_removal_confirmed() -> void:
	pass # Replace with function body.


func _on_confirm_output_removal_confirmed() -> void:
	pass # Replace with function body.


func _on_confirm_cancellation_confirmed() -> void:
	hide()
	back_to_defaults()
