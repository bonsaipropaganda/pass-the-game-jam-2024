## This is used for more than just the main deck, it displays cards in other UI also.
extends Control

signal card_selected(index: int)

const X_GAP = 30

@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@export var card_scene : PackedScene

var prev_selected_card := 0

## It is up to the game_manager to call this when needed
func update(cards:Array[CardResource], selected_card_index : int):
	var children = get_children()

	var card_start_x = (scene_width / 2.0) - ((len(cards)-1.0) * (X_GAP) / 2.0)

	for i in len(cards):
		var card: CardUI 

		if len(children) > i:
			card = children[i]
		else:
			card = card_scene.instantiate()
			add_child(card)
			card.clicked.connect(func(_x): card_selected.emit(i))

		card.set_card_text(cards[i].card_name, cards[i].description)
		card.set_selected(i == selected_card_index)
		card.set_card_resource(cards[i])
		card.global_position.x = card_start_x + (i * X_GAP)

	for i in range(len(cards), len(children)):
		children[i].queue_free()
		