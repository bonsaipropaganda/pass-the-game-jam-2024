extends Node2D
class_name CardUI

signal mouse_entered()
signal mouse_exited()
signal clicked(card_ui:CardUI)

const SCALE_MIN = 0.3
const SCALE_MAX = 0.6

var old_z_index := z_index 
var card_resource : CardResource # Stored by reference, not value
var hovered: bool = false

func set_card_resource(card:CardResource):
	card_resource = card


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
	mouse_entered.emit()
	hovered = true
	AudioManager.sfx_play(AudioManager.sfx_enum.PAPER_1, 0.2, -6.0)
	old_z_index = z_index
	z_index = 100
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MAX, SCALE_MAX), 0.25).from_current().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)


func _on_color_rect_mouse_exited() -> void:
	mouse_exited.emit()
	hovered = false
	z_index = old_z_index
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(SCALE_MIN, SCALE_MIN), 0.25).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		
		clicked.emit(card_resource)
