class_name Chest extends AnimatedSprite2D


func open():
	#SignalBus.chest_opened.Emit()
	queue_free()

