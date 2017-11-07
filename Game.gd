extends Node2D

const PLAYER_COUNT = 4
const STARTING_SHIPS = 5
const STARTING_WORLDS = 1
const COLOR_ARRAY = [Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255), Color(255, 255, 0), Color(255, 0, 255), Color(0, 255, 255)]

var player_scene = load("res://Player.tscn")
var players = []
var current_player = 0
var default_player = player_scene.instance()

func _ready():
	var galaxy_scene = load("res://Galaxy.tscn")
	
	for p in range(PLAYER_COUNT):
		var new_p = player_scene.instance()
		add_child(new_p)
		new_p.init(COLOR_ARRAY[p], p + 1)
		new_p.add_to_group("players")
		players.append(new_p)
	
	var new_g = galaxy_scene.instance()
	add_child(new_g)
	
	set_starting_content()
	
	var ui = self.get_node("Control")
	ui.update_label()

func set_starting_content():
	var stars = get_tree().get_nodes_in_group("stars")
	for p in players:
		var worlds_generated = 0
		while worlds_generated < STARTING_WORLDS:
			var sp = stars[randi() % stars.size()].get_planets()
			var to_gen = sp[randi() % sp.size()]
			if to_gen.owner_id == 0:
				to_gen.set_owner(p)
				to_gen.create_starbase(p)
				for s in range(STARTING_SHIPS):
					to_gen.create_ship(p)
				to_gen.update_ship_display()
				worlds_generated += 1

func next_turn():
	if current_player >= players.size():
		current_player = 1
	else:
		current_player += 1
	players[current_player - 1].update_resources()
	for s in get_tree().get_nodes_in_group("ships"):
		s.selected = false
	for p in get_tree().get_nodes_in_group("planets"):
		p.update_ship_display()