class_name HeroPaladin extends Entity

func _ready() -> void:
	Ref.hero_paladin = self
	type = E.EntityType.HERO
	specific_type = E.EntitySpecificType.PALADIN
