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
		# if only one ship in orbit is selected, destroy it and colonize this planet
		if get_selected_ships().size() == 1:
			colonize(get_selected_ships()[0])
		for s in get_tree().get_nodes_in_group("ships"):
			if s.selected == true and get_parent().hyperlanes.has(s.get_parent().get_parent()):
				move_ship_here(s)

func colonize(ship):
	for s in get_ships():
		if s.owner_id != ship.owner_id:
			return
	if ship.owner_id == self.owner_id:
		return
	set_owner(get_tree().get_root().get_node("Game").players[get_selected_ships()[0].owner_id - 1])
	remove_child(get_selected_ships()[0])
	update_ship_display()

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

func get_selected_ships_by_owner(owner):
	var selected_ships = []
	for s in get_ships():
		if s.selected == true and s.owner_id == owner.id:
			selected_ships.append(s)
	return selected_ships

func get_ships():
	var ships = []
	for c in self.get_children():
		if c.is_in_group("ships"):
			ships.append(c)
	return ships

func update_ship_display():
	var labels = []
	for l in self.get_children():
		if l.get_type() == "Label":
			remove_child(l)
	var offset = 24
	
	for p in get_tree().get_root().get_node("Game").players:
		var count = 0
		var allied = []
		for s in get_ships():
			# print(s.owner)
			if s.owner_id == p.id:
				allied.append(s)
				count += 1
		if allied.size() > 0:
			for a in allied:
				a.set_pos(Vector2(offset, 0))
				a.hide()
			allied[0].show()
			
			var l = Label.new()
			self.add_child(l)
			l.set_pos(Vector2(offset - 8, 12))
			if get_selected_ships_by_owner(p).size() > 0:
				l.set_text("x%s\n(%s)" % [count, get_selected_ships_by_owner(p).size()])
			else:
				l.set_text("x%s" % count)

			offset += 24