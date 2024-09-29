# Upon taking damage, you are forced to discard a card
# You get to choose which card to discard out of 3
extends Node2D

const DISCARD_OPTIONS = 3

func show_cards(cards:Array[CardResource]):
	var shuffled = cards.duplicate(false)
	shuffled.shuffle()
	
	while len(shuffled) > DISCARD_OPTIONS:
		shuffled.pop_back()
