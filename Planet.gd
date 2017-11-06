extends "res://Ownable.gd"

var test_ship_count = 12
var ship_scene = load("res://Ship.tscn")
var starbase_scene = load("res://Starbase.tscn")

func _ready():
	# set conditions for ship label
	var l = self.get_node("Label")
	l.set_pos(Vector2(36, 0))

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		for s in get_tree().get_nodes_in_group("ships"):
			if s.selected == true and get_parent().hyperlanes.has(s.get_parent().get_parent()):
				move_ship_here(s)

func move_ship_here(s):
	var prev = s.get_parent()
	
	prev.remove_child(s)
	prev.update_ship_display()
	add_child(s)
	s.selected = false
	update_ship_display()

func create_starbase(owner):
	var s = starbase_scene.instance()
	s.set_owner(owner)
	add_child(s)
	s.set_pos(Vector2(-24, 0))

func create_ship(owner):
	var s = ship_scene.instance()
	s.set_owner(owner)
	add_child(s)
	s.add_to_group("ships")
	update_ship_display()

func count_ships():
	return get_ships().size()

func get_selected_ships():
	var selected_ships = []
	for s in get_ships():
		if s.selected == true:
			selected_ships.append(s)
	return selected_ships

func get_ships():
	var ships = []
	for c in self.get_children():
		if c.is_in_group("ships"):
			ships.append(c)
	return ships

func update_ship_display():
	var l = self.get_node("Label")
	var ship_count = count_ships()
	
	for c in self.get_children():
		if c.is_in_group("ships"):
			c.set_pos(Vector2(24, 0))
	
	if ship_count >= 1:
		l.set_text("x%s" % ship_count)
		for s in self.get_ships():
			s.hide()
		self.get_ships()[0].show()
	else:
		l.set_text("")
		
	if get_selected_ships().size() > 0:
		l.set_text("x%s (%s)" % [ship_count, get_selected_ships().size()])