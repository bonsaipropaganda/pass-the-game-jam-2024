@tool
extends Node2D


func _ready() -> void:
	$Sprite2D.visible = Engine.is_editor_hint()
	
	if not Engine.is_editor_hint():
		pass # Code goes in here


func spawn(enemy_packed:PackedScene) -> BaseEmemy:
	var e = enemy_packed.instantiate()
	get_parent().add_child(e) # Note get_parent here is bad practice. I am under time pressure.
	e.global_position = global_position
	return e


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		pass
