extends Node2D
class_name Exit

@export var next_room_type := E.RoomType.CARD_REWARD


func _ready() -> void:
	SignalBus.room_complete.connect(on_room_complete)
	SignalBus.player_move_started.connect($Area2D.set_monitoring.bind(false))
	SignalBus.player_move_ended.connect($Area2D.set_monitoring.bind(true))


func on_room_complete() -> void:
	$Area2D.set_deferred("monitoring", true)
	$FullSpritesheet.frame = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		await get_tree().create_timer(0.4).timeout # Let the player stand all the way on the tile. This is just a quick hack.
		# to use exit type enum in other scripts, do E.RoomType.TYPE
		# you can set the type of the variables that use it as int or E.RoomType
		SignalBus.next_level.emit(next_room_type)
