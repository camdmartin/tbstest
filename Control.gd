extends Control

func _ready():
	var b = get_node("End Turn")
	b.connect("pressed", self, "update_label")

func update_label():
	get_parent().next_turn()
	var current_player = get_parent().current_player
	get_node("Current Player").set_text("Player " + str(current_player) + "'s Turn")
	get_node("Current Player").add_color_override("font_color", get_parent().players[current_player - 1].color)

func update_resource_panel():
	var r = get_node("Resource Panel")
	r.set_text("")
	for p in get_parent().players:
		r.set_text(r.get_text() + "\n\nPlayer " + str(p.id) + "\nMetal: " + str(p.metal) + "\nFuel: " + str(p.fuel))