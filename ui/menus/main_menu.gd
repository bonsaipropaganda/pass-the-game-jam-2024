extends Control

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@export var scene_dungeon : PackedScene
@export var scene_test : PackedScene


## Called by StartButton's on_pressed signal when pressed
func _on_start_button_pressed() -> void:
	# Musical fade-out & button SFX
	AudioManager.music_transition_to(AudioManager.song_enum.GAMEPLAY_1, 5.0)
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	
	# Visual fade-out 
	var tween: Tween = create_tween()
	var fade_rectangle: ColorRect = $"UI/FadeRectangle"
	tween.set_parallel(false)
	fade_rectangle.mouse_filter = Control.MOUSE_FILTER_STOP
	tween.tween_property(fade_rectangle, "modulate", Color(1, 1, 1, 1), 2.0)
	tween.tween_property(fade_rectangle, "modulate", Color(1, 1, 1, 1), 1.0)
	
	# Visual fade-in
	await tween.finished
	get_tree().change_scene_to_packed(scene_dungeon)
	# Game manager will handle fade-in in _ready

func _on_start_2_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	get_tree().change_scene_to_packed(scene_test)

# Move camera to view credits
func _on_credits_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	# Smoothing will make this look nice
	# I know you wanted smoothing but I removed the Camera :_(.
	%CreditsMenu.visible = !%CreditsMenu.visible
	
# Move camera back
func _on_back_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	%CreditsMenu.visible = !%CreditsMenu.visible

func _on_quit_button_pressed() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	get_tree().quit()

var _last_time_soundcheck:int = 0
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sfx"), linear_to_db(value)
		)
	#so it doesnt spamm
	if Time.get_ticks_msec() - _last_time_soundcheck > 250:
		AudioManager.sfx_play(AudioManager.sfx_enum.DAMAGE)
		_last_time_soundcheck = Time.get_ticks_msec()


func _on_music_volume_slider_value_changed(value: float) -> void:
		AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), linear_to_db(value)
		)
