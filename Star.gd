extends Node2D

var max_planet_count = 4
var name = self.get_name()

func _ready():
	randomize()
	
	# name the star
	find_node("Star Name").set_text(self.name)
	
	# initialize the planets in the system
	var planet_scene = load("res://Planet.tscn")
	
	for i in range(randi() % max_planet_count + 2):
		var p = planet_scene.instance()
		p.set_pos(Vector2(0, 48 + 32 * i))
		add_child(p)
