# This represents the size of the room, where the camera will stop
@tool
extends Node2D


func _ready() -> void:
	visible = Engine.is_editor_hint()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2i.ZERO, Vector2(get_parent().room_size) * Global.TILE_SIZE), Color(1,1,1,0.5), false, 1.5)
