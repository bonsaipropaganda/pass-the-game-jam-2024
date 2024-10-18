extends ColorRect
class_name HealthBar

# Use the hurtbox size for the healh bar length. Manually assign this once for every new enemy type.
@export var collision_shape : CollisionShape2D

func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	var collision_rect : RectangleShape2D = collision_shape.shape
	size.x = collision_rect.size.x
	size.y = 3
	position.y = -3
	

func update(current_hp : float, max_hp : float) -> void:
	scale.x = current_hp/max_hp
	
