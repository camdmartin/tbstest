extends Area2D

var selected = false

func _ready():
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	var ships_on_planet = []
	for s in self.get_parent().get_ships():
		if s.selected == false:
			ships_on_planet.append(s)
	
	if ships_on_planet.size() > 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and Input.is_action_pressed("single_select"):
			# CTRL-click for single ships
			ships_on_planet[0].selected = true
			print("selected")
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and Input.is_action_pressed("batch_select"):
			# SHIFT-click for groups of 5
			if ships_on_planet.size() > 5:
				for i in range(4):
					ships_on_planet[i].selected = true
			else:
				for s in ships_on_planet:
					s.selected = true
		elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
			# left click selects all ships
			for s in ships_on_planet:
				s.selected = true
	self.get_parent().update_ship_display()