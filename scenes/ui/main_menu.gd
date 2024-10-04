extends Node2D

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var next_scene = preload("res://scenes/main.tscn")
@onready var _grid_refactor_scene = preload("res://world.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_start_button_pressed() -> void:
	animation_player.play("fade")

func _on_start_2_button_pressed() -> void:
	get_tree().change_scene_to_packed(_grid_refactor_scene)

# Move camera to view credits
func _on_credits_button_pressed() -> void:
	# Smoothing will make this look nice
	$Camera2D.position.x = scene_width

# Move camera back
func _on_back_button_pressed() -> void:
	$Camera2D.position.x = 0

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(next_scene)
