extends Control

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")


func start():
	$"UI/Main Menu/Labels/RoomsClearedLabel".text = "Rooms Cleared: " + str(Global.game_manager.rooms_cleared)
	$"UI/Main Menu/Labels/BestScoreLabel".clear()
	$"UI/Main Menu/Labels/BestScoreLabel".append_text(fun_with_dying_text())
	$UI.visible = true

## Death Menu's $"UI/Main Menu/Labels/BestScoreLabel" text change, in BBCode
func fun_with_dying_text() -> String:
	var text = ""
	var save = Global.game_manager.load_scores()
	print("scores should be there")
	if not save:
		return "- [color=yellow] NEW BEST!!! [/color] -"
	var recent_score = Global.game_manager.rooms_cleared
	
	if check_if_highest(save.everyRunRoomsBeaten, recent_score):
			return "- [color=yellow] NEW BEST!!! [/color] -"
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var rand = rng.randi() % 3 # Number of alternatives, fill em in.
		match rand:
			0:
				return "alright."
			1:
				return "this is your " + str(save.everyRunRoomsBeaten.size() + 1) + " run"
			2:
				return "farewell, [color=red]MORTAL COIL[/color]"
	return text


func check_if_highest(arr:Array[int],score:int) -> bool:
	var highest = 0
	for run in arr:
		if run > highest:
			highest = run
	if score > highest:
		return true
	return false

func _on_main_menu_button_pressed() -> void:
	AudioManager.music_transition_to(AudioManager.song_enum.GAMEPLAY_1, 3.0)
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	get_tree().quit()

func _on_button_hovered():
	AudioManager.sfx_play(AudioManager.sfx_enum.SELECT, 0.2)

var _last_time_soundcheck:int = 0
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sfx"), value
		)
	#so it doesnt spamm
	if Time.get_ticks_msec() - _last_time_soundcheck > 250:
		AudioManager.sfx_play(AudioManager.sfx_enum.DAMAGE)
		_last_time_soundcheck = Time.get_ticks_msec()


func _on_music_volume_slider_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), value
		)
