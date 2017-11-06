extends "res://Ownable.gd"

const INITIAL_SHIPS = 5

func _ready():
	pass

func set_random_owner():
	var players = get_tree().get_nodes_in_group("players")
	owner = players[randi() % players.size()]

func create_starter_ships():
	for i in range(INITIAL_SHIPS):
		self.get_parent().create_ship(self.owner)

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		self.get_parent().create_ship(self.owner)