extends Node2D
class_name CardUI

signal clicked(card_ui:CardUI)

const SCALE_MIN = 0.3
const SCALE_MAX = 0.6

var old_z_index = z_index


func set_card_text(cname, cdesc):
	$NameLabel.text = cname
	$DescriptionLabel.text = cdesc


func set_selected(enable:bool):
	if enable:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0


func _ready() -> void:
	scale.x = SCALE_MIN
	scale.y = SCALE_MIN


# We use colorrect to get mouse because it is a control, and captures the input
func _on_color_rect_mouse_entered() -> void:
	old_z_index = z_index
	z_index = 100
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MAX, SCALE_MAX), 0.3).from_current()


func _on_color_rect_mouse_exited() -> void:
	z_index = old_z_index
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MIN, SCALE_MIN), 0.3).from_current()


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("clicked", self)
