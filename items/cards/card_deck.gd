## This is used for more than just the main deck, it displays cards in other UI also.
extends Control

const X_GAP = 30

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@export var card_scene : PackedScene

## It is up to the game_manager to call this when needed
func update(cards:Array[CardResource], selected_card:CardResource):
	# Note - quick and dirty way of implementing this function...
	for c in get_children():
		c.queue_free()
	
	var card_start_x = (scene_width / 2.0) - ((len(cards)-1.0) * (X_GAP) / 2.0)
	
	for i in len(cards):
		var card = card_scene.instantiate()
		card.z_index = i
		card.set_card_text(cards[i].card_name, cards[i].description)
		card.set_selected(cards[i] == selected_card)
		card.set_card_resource(cards[i])
		
		add_child(card)
		card.global_position.x = card_start_x + (i * X_GAP)
