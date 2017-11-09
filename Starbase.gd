extends "res://Ownable.gd"

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	var current_player = get_tree().get_root().get_node("Game").current_player
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed and self.owner_id == current_player.id:
		if self.get_owner().metal > 0:
			self.get_parent().create_ship(self.get_owner(), 0)
	elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed and self.owner_id != current_player.id and get_tree().get_root().get_node("Game").current_player.fuel > 2:
		var enemy_fleet = get_parent().get_selected_ships_by_owner(get_tree().get_root().get_node("Game").current_player)
		if enemy_fleet.size() > 2:
			self.queue_free()
			for i in range(2):
				get_parent().remove_child(enemy_fleet[0])
				get_parent().starbases = []
				enemy_fleet.remove(0)
		elif enemy_fleet.size() > 0:
			for i in range(enemy_fleet.size()):
				get_parent().remove_child(enemy_fleet[0])
				get_parent().starbases = []
				enemy_fleet.remove(0)
		get_parent().update_ship_display()