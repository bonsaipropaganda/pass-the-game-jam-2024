extends Node2D
class_name Exit

enum ExitType {
	CARD_REWARD,
	MONEY_REWARD,
	SHOP,
	BOSS,
}

@export var exit_type := ExitType.CARD_REWARD


func _ready() -> void:
	Global.room_complete.connect(on_room_complete)


func on_room_complete() -> void:
	$Area2D.set_deferred("monitoring", true)
	$FullSpritesheet.frame = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		await get_tree().create_timer(0.4).timeout # Let the player stand all the way on the tile. This is just a quick hack.
		# to use exit type enum in other scripts, do Exit.ExitType.TYPE
		# you can set the type of the variables that use it as int or Exit.ExitType
		Global.next_level.emit(exit_type)
