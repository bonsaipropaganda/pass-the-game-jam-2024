class_name Chest extends AnimatedSprite2D

# most of the logic is handled in game_manager
# yeah this function feels lonely
func open():
	queue_free()

