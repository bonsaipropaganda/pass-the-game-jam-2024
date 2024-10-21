extends Area2D

func _ready():
	$AnimatedSprite2D.play()


func _on_area_entered(area):
	if area.is_in_group("player_area"):
		Global.game_manager.money += 1
		queue_free()
