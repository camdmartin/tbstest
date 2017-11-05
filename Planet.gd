extends Node2D

var test_ship_count = 4

func _ready():
	var ship_scene = load("res://Ship.tscn")
	for i in range(randi() % test_ship_count):
		var s = ship_scene.instance()
		add_child(s)
		s.set_pos(Vector2(24, 0))
