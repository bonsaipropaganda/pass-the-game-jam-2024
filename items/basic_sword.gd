extends Sprite2D

@export var item_data: SwordItem

func _ready():
	if item_data:
		print("This is a", item_data.name, "with", item_data.damage, "damage.")
