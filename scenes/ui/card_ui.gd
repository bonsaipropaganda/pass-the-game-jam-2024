extends Node2D

const SCALE_MIN = 0.3
const SCALE_MAX = 1.0

#@onready var tween = create_tween()

func _ready() -> void:
	scale.x = SCALE_MIN
	scale.y = SCALE_MIN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MAX, SCALE_MAX), 0.5).from_current()


func _on_area_2d_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MIN, SCALE_MIN), 0.5).from_current()
