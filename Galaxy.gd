extends Node2D

const STAR_GEN_RADIUS = 200
const MIN_HYPERLANES = 3
const HYPERLANE_VARIANCE = 1
const MAX_STARS = 8
const BORDER_SIZE = 100

var generator_x = 1000
var generator_y = 1000
var star_scene = load("res://Star.tscn")

func _ready():
	generator_x = get_viewport().get_rect().size.x - 2 * BORDER_SIZE
	generator_y = get_viewport().get_rect().size.y - 2 * BORDER_SIZE
	collider_star_gen()
	set_hyperlanes()
	
func collider_star_gen():
	for i in range(MAX_STARS):
		var s = create_star()
		s.set_pos(Vector2(rand_range(BORDER_SIZE, generator_x), rand_range(BORDER_SIZE, generator_y)))
		while true:
			var has_collision = false
			for c in self.get_children():
				if c != s and c.get_pos().distance_to(s.get_pos()) < STAR_GEN_RADIUS:
					has_collision = true
					break
			if has_collision == false:
				break
			else:
				s.set_pos(Vector2(rand_range(BORDER_SIZE, generator_x), rand_range(BORDER_SIZE, generator_y)))

func set_hyperlanes():
	for s in self.get_children():
		var lane_potentials = {}
		for i in self.get_children():
			lane_potentials[s.get_pos().distance_to(i.get_pos())] = i
		
		var organized = lane_potentials.keys()
		organized.sort()
		
		for i in range(randi() % HYPERLANE_VARIANCE + MIN_HYPERLANES):
			var t = lane_potentials[organized[i]]
			s.hyperlanes.append(t)
			t.hyperlanes.append(s)

func create_star():
	var s = star_scene.instance()
	s.add_to_group("stars")
	add_child(s)
	return s

func _draw():
	for star in get_tree().get_nodes_in_group("stars"):
		for h in star.hyperlanes:
			draw_line(star.get_pos(), h.get_pos(), Color(100, 100, 100), 0.75)