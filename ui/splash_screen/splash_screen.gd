extends Control


## The current splash screen's animation is by KenneyNL
## https://github.com/KenneyNL/Godot-SplashScreens/tree/main

# If you change the splash screen,
# try to keep it timed with the music :D
# (for that, menu must appear at ~5.5 seconds)

func _ready() -> void:
	$VideoStreamPlayer.play()
	
	get_tree().create_timer(0.4).timeout.connect(
		func ():
			AudioManager.music_transition_to(AudioManager.song_enum.MENU)
	)
	
 

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(
		preload("res://ui/menus/main_menu.tscn")
	)
