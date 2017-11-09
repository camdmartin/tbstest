extends Node2D

const BASE_METAL = 1
const BASE_FUEL = 3

# these are default values, should be changed after creation
var color = Color(255, 255, 255)
var id = 0

var properties = []
var metal = BASE_METAL
var fuel = BASE_FUEL

var defeated = false

func _ready():
	pass
	
func init(color, id):
	self.color = color
	self.id = id
	
func get_color():
	return self.color

func add_possession(object):
	for p in get_parent().players:
		if p.id != self.id and p.properties.has(object):
			p.properties.remove(p.properties.find(object))
	self.properties.append(object)

func update_resources():
	self.fuel = BASE_FUEL
	self.metal = BASE_METAL
	for p in properties:
		if p.get_filename() == "res://Planet.tscn":
			if p.world_type == "terrestrial":
				self.metal += 2
			elif p.world_type == "gas_giant":
				self.fuel += 5

func lose_game():
	for s in get_tree().get_nodes_in_group("ships"):
		if s.owner_id == id:
			var p = s.get_parent()
			s.queue_free()
			p.update_ship_display()
	properties = []