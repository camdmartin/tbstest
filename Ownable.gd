extends Area2D

const DEFAULT_COLOR = Color(255, 255, 255)

var owner_id = 0
var color = DEFAULT_COLOR

func _ready():
	pass

func set_owner(owner):
	self.owner_id = owner.id
	self.color = owner.color
	owner.add_possession(self)
	find_node("Sprite").set_modulate(self.color)

func get_owner():
	return get_tree().get_root().get_node("Game").get_player_by_id(owner_id)