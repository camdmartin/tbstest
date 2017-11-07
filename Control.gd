extends Control

func _ready():
	var b = get_node("End Turn")
	b.connect("pressed", self, "update_label")
	
	var player_info = load("res://Player Info.tscn")
	var offset = 0
	for p in get_parent().players:
		print("instancing")
		var pi = player_info.instance()
		get_node("Resource Panel").add_child(pi)
		pi.set_pos(Vector2(0, 64 * offset))
		offset += 1
		
		pi.get_node("Player").add_color_override("font_color", p.color)
		pi.get_node("Player").set_text("Player " + str(p.id))
		pi.get_node("Metal").set_text("Metal: " + str(p.metal))
		pi.get_node("Fuel").set_text("Fuel: " + str(p.fuel))

func update_label():
	get_parent().next_turn()
	var current_player = get_parent().current_player
	get_node("Current Player").set_text("Player " + str(current_player) + "'s Turn")
	get_node("Current Player").add_color_override("font_color", get_parent().players[current_player - 1].color)

func update_resource_panel():
	var r = get_node("Resource Panel")
	var curr = 0
	for pi in r.get_children():
		var p = get_parent().players[curr]
		pi.get_node("Metal").set_text("Metal: " + str(p.metal))
		pi.get_node("Fuel").set_text("Fuel: " + str(p.fuel))
		curr += 1