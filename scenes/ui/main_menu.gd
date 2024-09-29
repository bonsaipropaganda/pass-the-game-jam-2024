extends Node2D

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var next_scene = preload("res://scenes/main.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)


# Move camera to view credits
func _on_credits_button_pressed() -> void:
	# Smoothing will make this look nice
	$Camera2D.position.x = scene_width


# Move camera back
func _on_back_button_pressed() -> void:
	$Camera2D.position.x = 0


func _on_quit_button_pressed() -> void:
	get_tree().quit()
