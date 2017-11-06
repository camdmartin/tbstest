extends Area2D

const DEFAULT_COLOR = Color(255, 255, 255)

var owner = 0
var color = DEFAULT_COLOR

func _ready():
	var player_scene = load("res://Player.tscn")
	var default_player = player_scene.instance()
	owner = default_player

func set_owner(owner):
	self.owner = owner
	self.color = owner.color
	find_node("Sprite").set_modulate(self.color)