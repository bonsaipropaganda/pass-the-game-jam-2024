extends Control

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@export var scene_main_menu : PackedScene

func _ready() -> void:
	$UI/FadeRectangle.show()
	#fade from black using FadeRectangle
	var tween = get_tree().create_tween()
	tween.tween_property(
		$UI/FadeRectangle,
		"color",
		Color(1.0, 1.0, 1.0, 0.0),
		1.0 # 1 second
	).set_trans(Tween.TRANS_CUBIC)


func _on_main_menu_button_pressed() -> void:
	AudioManager.music_transition_to(AudioManager.song_enum.GAMEPLAY_1, 3.0)
	AudioManager.sfx_play(AudioManager.sfx_enum.BUTTON, 0.0)
	get_tree().change_scene_to_packed(scene_main_menu)

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