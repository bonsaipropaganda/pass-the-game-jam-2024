extends Node2D

const X_GAP = 20
const CARD_WIDTH = 50
@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")

# It is up to the game_manager to call this when needed
func update(cards, selected_cards):
	pass
