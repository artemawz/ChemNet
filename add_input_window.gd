extends Window

signal chemical_or_item_added(item: Variant)

var selected_idx := -1
var selected: Variant = null
var selected_is_item := false # true = item, false = chemical

func _on_chemical_selection_item_selected(index: int) -> void:
	%RemoveSelected.disabled = false


func _on_add_item_pressed() -> void:
	%AddItemWindow.popup()


func _on_add_chemical_pressed() -> void:
	%AddChemicalWindow.popup()


func _on_remove_selected_pressed() -> void:
	if selected_is_item:
		%ConfirmationDialog.title = "Remove item confirmation"
		%ConfirmationDialog.dialog_text = "Do you really want to remove item %s?" % selected
		%ConfirmationDialog.dialog_text = "Do you really want to remove item %s?" % selected
	else:
		%ConfirmationDialog.title = "Remove chemical confirmation"


func _on_cancel_pressed() -> void:
	pass # Replace with function body.


func _on_add_pressed() -> void:
	pass # Replace with function body.


func _on_add_chemical_window_chemical_added(chemical: Chemical) -> void:
	pass # Replace with function body.


func _on_about_to_popup() -> void:
	back_to_default()

func back_to_default() -> void:
	update_selection()
	%ChemicalSelection.select(%ChemicalSelection.item_count - 1)
	%RemoveSelected.disabled = true

func update_selection() -> void:
	%ChemicalSelection.clear()
	
	for item in ItemRegister.keys():
		%ChemicalSelection.add_item(item)
		
	for chemical in ChemicalRegister.keys():
		%ChemicalSelection.add_item(chemical)
