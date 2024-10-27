extends Control


func _on_back_pressed():
	var tween: Tween = create_tween()
	tween.tween_property($TransitionRect, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://ui/splash_screen/splash_screen.tscn")


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_F:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif event.keycode == KEY_ESCAPE:
			
