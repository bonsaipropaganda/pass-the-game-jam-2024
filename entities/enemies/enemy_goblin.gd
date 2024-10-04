class_name EnemyGoblin extends Entity

func _ready() -> void:
	type = E.EntityType.ENEMY
	specific_type = E.EntitySpecificType.GOBLIN
