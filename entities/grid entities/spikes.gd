extends Area2D

func _ready():
	$AnimatedSprite2D.play()


func _on_area_entered(area):
	if area.is_in_group("player_area"):
		area.get_parent().take_damage()
