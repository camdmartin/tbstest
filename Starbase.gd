extends "res://Ownable.gd"

const INITIAL_SHIPS = 5

func _ready():
	pass

func create_starter_ships():
	for i in range(INITIAL_SHIPS):
		self.get_owner().metal += 1
		self.get_parent().create_ship(self.owner)

func _input_event(viewport, event, shape_idx):
	var current_player = get_tree().get_root().get_node("Game").current_player
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed and self.owner_id == current_player:
		if self.get_owner().metal > 0:
			self.get_parent().create_ship(self.get_owner())