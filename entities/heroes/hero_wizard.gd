class_name HeroWizard extends Entity

func _ready() -> void:
	Ref.hero_wizard = self
	type = E.EntityType.HERO
	specific_type = E.EntitySpecificType.WIZARD
