extends Area2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and event.pressed:
		self.get_parent().create_ship()