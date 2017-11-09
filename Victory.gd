extends Control

func _ready():
	var b = get_node("New Game")
	b.connect("pressed", self, "new_game")

func new_game():
	get_parent().get_parent().new_game()
