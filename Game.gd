extends Node2D

const PLAYER_COUNT = 2
const STARTING_SHIPS = 5
const STARTING_WORLDS = 1
const COLOR_ARRAY = [Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255)]

var player_scene = load("res://Player.tscn")
var default_player = player_scene.instance()

func _ready():
	var galaxy_scene = load("res://Galaxy.tscn")
	
	for p in range(PLAYER_COUNT):
		var new_p = player_scene.instance()
		add_child(new_p)
		new_p.init(COLOR_ARRAY[p], p + 1)
		new_p.add_to_group("players")
	
	var new_g = galaxy_scene.instance()
	add_child(new_g)