extends "res://Ownable.gd"

var selected = false
const BATCH_SELECT_SIZE = 5

func _ready():
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	var ships_on_planet = []
	for s in self.get_parent().get_ships():
		if s.selected == false:
			ships_on_planet.append(s)
	
	if ships_on_planet.size() > 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed() and Input.is_action_pressed("single_select"):
			# CTRL-click for single ships
			ships_on_planet[0].selected = true
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed() and Input.is_action_pressed("batch_select"):
			# SHIFT-click for batches of specified size
			if ships_on_planet.size() > BATCH_SELECT_SIZE:
				for i in range(BATCH_SELECT_SIZE):
					ships_on_planet[i].selected = true
			else:
				for s in ships_on_planet:
					s.selected = true
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed():
			# left click selects all ships
			for s in ships_on_planet:
				s.selected = true
	# deselection
	var ships_on_planet = []
	for s in self.get_parent().get_ships():
		if s.selected == true:
			ships_on_planet.append(s)
	
	if ships_on_planet.size() > 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed() and Input.is_action_pressed("single_select"):
			# CTRL-click for single ships
			ships_on_planet[0].selected = false
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed() and Input.is_action_pressed("batch_select"):
			# SHIFT-click for batches of specified size
			if ships_on_planet.size() > BATCH_SELECT_SIZE:
				for i in range(BATCH_SELECT_SIZE):
					ships_on_planet[i].selected = false
			else:
				for s in ships_on_planet:
					s.selected = false
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_RIGHT and event.is_pressed():
			# right click deselects all ships
			for s in ships_on_planet:
				s.selected = false
				
	self.get_parent().update_ship_display()