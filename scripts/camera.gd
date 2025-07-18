extends Camera2D


func _process(delta: float) -> void:
	# Get all UI elements (e.g., UIManager)
	var ui_elements = get_tree().get_nodes_in_group("UIElements")
	
	# Ensure each UI element stays at a fixed position relative to the screen
	for ui_element in ui_elements:
		if ui_element:
			# Reset the UI element's position to the top-left corner of the screen
			ui_element.set_position(Vector2(30, 10))
		
