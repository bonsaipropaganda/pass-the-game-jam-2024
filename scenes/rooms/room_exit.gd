extends Node2D
class_name Exit

enum ExitType {
	CARD_REWARD,
	MONEY_REWARD,
	SHOP,
	BOSS,
}

@export var exit_type = ExitType.CARD_REWARD


func _ready() -> void:
	Global.connect("room_complete", on_room_complete)


func on_room_complete() -> void:
	$Area2D.set_deferred("monitoring", true)
	$Sprite2D.frame = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		await get_tree().create_timer(0.4).timeout # Let the player stand all the way on the tile. This is just a quick hack.
		Global.emit_signal("next_level", exit_type) # TODO other nodes don't know what exit_type is so it's kinda useless
