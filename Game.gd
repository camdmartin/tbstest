extends Node2D

const PLAYER_COUNT = 1
const STARTING_SHIPS = 5
const STARTING_WORLDS = 1
const COLOR_ARRAY = [Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255), Color(255, 255, 0), Color(255, 0, 255), Color(0, 255, 255)]

var player_scene = load("res://Player.tscn")
var ui_control = load("res://UI.tscn")
var players = []
var default_player = player_scene.instance()
var current_player = default_player

func _ready():
	var galaxy_scene = load("res://Galaxy.tscn")
	add_child(default_player)
	
	for p in range(PLAYER_COUNT):
		var new_p = player_scene.instance()
		add_child(new_p)
		new_p.init(COLOR_ARRAY[p], p + 1)
		new_p.add_to_group("players")
		players.append(new_p)
	
	current_player = players[0]
	
	var new_g = galaxy_scene.instance()
	add_child(new_g)
	
	var control = ui_control.instance()
	add_child(control)
	
	set_starting_content()
	
	control.update_label()
	control.update_resource_panel()

func new_game():
	# boot back to splash screen
	pass

func set_starting_content():
	var stars = get_tree().get_nodes_in_group("stars")
	for p in players:
		var worlds_generated = 0
		while worlds_generated < STARTING_WORLDS:
			var sp = stars[randi() % stars.size()].get_planets()
			var to_gen = sp[randi() % sp.size()]
			if to_gen.owner_id == 0:
				to_gen.set_owner(p)
				to_gen.create_starbase(p, 0)
				for s in range(STARTING_SHIPS):
					to_gen.create_ship(p, 0)
				to_gen.update_ship_display()
				worlds_generated += 1

func get_player_by_id(id):
	for p in players:
		if p.id == id:
			return p

func next_turn():
	print(get_children())
	for p in players:
		var defeated = true
		for r in p.properties:
			if (!weakref(r).get_ref()):
				pass
			else:
				if r.get_filename() == "res://Starbase.tscn" or r.get_filename() == "res://Planet.tscn":
					defeated = false
		p.defeated = defeated
		if p.defeated == true:
			print("Player " + str(p.id) + " has fallen.")
	
	for p in players:
		if p.defeated == true:
			p.lose_game()
			players.remove(players.find(p))
			p.queue_free()
	
	if players.size() == 1:
		get_node("UI").get_node("Victory").show()
	
	var i = players.find(current_player)
	
	if  i >= players.size() - 1:
		current_player = players[0]
	else:
		current_player = players[i + 1]

	current_player.update_resources()
	get_node("UI").update_resource_panel()
	for s in get_tree().get_nodes_in_group("ships"):
		s.selected = false
	for p in get_tree().get_nodes_in_group("planets"):
		p.update_ship_display()
	get_node("UI").update_label()