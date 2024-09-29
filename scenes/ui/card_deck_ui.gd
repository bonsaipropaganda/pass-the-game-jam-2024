# This is used for more than just the main deck, it displays cards in other UI also.
extends Node2D

const X_GAP = 30

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var card_ui_packed = preload("res://scenes/ui/card_ui.tscn")

# It is up to the game_manager to call this when needed
func update(cards:Array[CardResource], selected_card:CardResource):
	# Note - quick and dirty way of implementing this function...
	for c in get_children():
		c.queue_free()
	
	var card_start_x = (scene_width / 2) - ((len(cards)-1) * (X_GAP) / 2)
	
	for i in len(cards):
		var card = card_ui_packed.instantiate()
		card.z_index = i
		card.set_card_text(cards[i].card_name, cards[i].description)
		card.set_selected(cards[i] == selected_card)
		card.set_card_resource(cards[i])
		
		add_child(card)
		card.global_position.x = card_start_x + (i * X_GAP)
