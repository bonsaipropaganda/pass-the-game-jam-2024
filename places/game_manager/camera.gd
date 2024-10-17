extends Camera2D

# Follow player
func _process(_delta: float) -> void:
	var p = get_tree().get_first_node_in_group("player")
	if p:
		global_position = p.global_position
