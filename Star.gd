extends Node2D

const MAX_PLANET_COUNT = 4
const MAX_HYPERLANES = 2

var name = self.get_name()
var hyperlanes = []

var planet_scene = load("res://Planet.tscn")

func _ready():
	randomize()

	# name the star
	find_node("Star Name").set_text(self.name)
	
	# initialize the planets in the system
	var planet_count = randi() % MAX_PLANET_COUNT + 2
	
	for i in range(planet_count):
		create_planet(get_tree().get_root().get_node("Game").default_player)

func create_planet(owner):
	var p = planet_scene.instance()
	p.set_owner(owner)
	add_child(p)
	p.add_to_group("planets")
	p.set_pos(Vector2(0, 16 + 32 * get_planets().size()))
	set_random_planet_type(p)

func set_random_planet_type(planet):
	var i = rand_range(-1, 1)
	if i < 0:
		planet.world_type = "terrestrial"
		planet.get_node("Sprite").set_texture(load("res://terrestrial.png"))
	else:
		planet.world_type = "gas_giant"
		planet.get_node("Sprite").set_texture(load("res://gas_giant.png"))

func get_planets():
	var planets = []
	for p in get_children():
		if p.is_in_group("planets"):
			planets.append(p)
	return planets