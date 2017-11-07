extends Node2D

# these are default values, should be changed after creation
var color = Color(255, 255, 255)
var id = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func init(color, id):
	self.color = color
	self.id = id
	
func get_color():
	return self.color
