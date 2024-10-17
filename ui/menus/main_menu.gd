extends Control

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@export var scene_dungeon : PackedScene
@export var scene_test : PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene_dungeon)

func _on_start_2_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene_test)

# Move camera to view credits
func _on_credits_button_pressed() -> void:
	# Smoothing will make this look nice
	# I know you wanted smoothing but I removed the Camera :_(.
	%"Credits Menu".visible = !%"Credits Menu".visible
	
# Move camera back
func _on_back_button_pressed() -> void:
	%"Credits Menu".visible = !%"Credits Menu".visible

func _on_quit_button_pressed() -> void:
	get_tree().quit()
