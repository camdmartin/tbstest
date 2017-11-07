extends "res://Ownable.gd"

var selected = false
const BATCH_SELECT_SIZE = 5

func _ready():
	set_process_input(true)

func is_enemy_in_orbit():
	for s in get_parent().get_ships():
		if s.owner_id != owner_id:
			return true
	if get_parent().starbases.size() > 0:
		if get_parent().starbases[0].owner_id != owner_id:
			return true
	return false

func _input_event(viewport, event, shape_idx):
	var ships_on_planet = []
	var current_player = get_tree().get_root().get_node("Game").current_player
	var planet = get_parent()
	
	if self.owner_id == current_player:
		for s in self.get_parent().get_ships():
			if s.selected == false and s.owner_id == current_player:
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
			if s.selected == true and s.owner_id == current_player:
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
	# fighting costs 2 fuel
	elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.is_pressed() and get_tree().get_root().get_node("Game").players[current_player - 1].fuel > 2:
		# compile fleets in combat
		if get_parent().get_selected_ships_by_owner(get_tree().get_root().get_node("Game").players[current_player - 1]).size() > 0:
			var enemy_fleet = [] # the current player's fleet
			var allied_fleet = [] # this ship (the target)'s fleet
			for s in get_parent().get_ships():
				if s.owner_id == current_player:
					enemy_fleet.append(s)
				elif s.owner_id == owner_id:
					allied_fleet.append(s)
			# calculate casualties
			var allied_casualties = max(1, int(round(enemy_fleet.size() / 2)))
			var enemy_casualties = max(1, int(round(allied_fleet.size() / 2)))
			if planet.starbases.size() > 0:
				if planet.starbases[0].owner_id == current_player:
					allied_casualties += 2
				elif planet.starbases[0].owner_id == owner_id:
					enemy_casualties += 2
			# resolve combat, destroy ships
			for i in range(allied_casualties):
				if allied_fleet.size() > 0:
					planet.destroy_ship(allied_fleet[0])
					allied_fleet.remove(0)
			for i in range(enemy_casualties):
				if enemy_fleet.size() > 0:
					planet.destroy_ship(enemy_fleet[0])
					enemy_fleet.remove(0)
	planet.update_ship_display()