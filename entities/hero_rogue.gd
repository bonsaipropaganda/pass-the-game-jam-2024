class_name HeroRogue extends Entity

func _ready() -> void:
	Ref.hero_rogue = self
	type = E.EntityType.HERO
	specific_type = E.EntitySpecificType.ROGUE
