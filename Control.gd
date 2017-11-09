extends Control

var player_info = load("res://Player Info.tscn")

func _ready():
	var b = get_node("End Turn")
	b.connect("pressed", self, "next_turn")

func update_label():
	var current_player = get_parent().current_player
	get_node("Current Player").set_text("Player " + str(current_player.id) + "'s Turn")
	get_node("Current Player").add_color_override("font_color", current_player.color)

func next_turn():
	get_parent().next_turn()

func update_resource_panel():
	for c in get_node("Resource Panel").get_children():
		c.queue_free()
	
	var offset = 0
	
	for p in get_parent().players:
		var pi = player_info.instance()
		get_node("Resource Panel").add_child(pi)
		pi.set_pos(Vector2(0, 64 * offset))
		offset += 1
		
		pi.get_node("Player").add_color_override("font_color", p.color)
		pi.get_node("Player").set_text("Player " + str(p.id))
		pi.get_node("Metal").set_text("Metal: " + str(p.metal))
		pi.get_node("Fuel").set_text("Fuel: " + str(p.fuel))