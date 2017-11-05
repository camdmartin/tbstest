extends Node2D

var max_planet_count = 4
var name = "Alpha Centauri"

func _ready():
	randomize()
	var planet_scene = load("res://Planet.tscn")
	find_node("Star Name").set_text(self.name)
	for i in range(randi() % max_planet_count):
		var p = planet_scene.instance()
		p.set_pos(Vector2(0, 48 + 32 * i))
		add_child(p)
