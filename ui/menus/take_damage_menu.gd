# Upon taking damage, you are forced to discard a card
# You get to choose which card to discard out of 3
extends Control

const DISCARD_OPTIONS = 3


func show_cards(cards:Array[CardResource], card_choice_callback:Callable):
	var shuffled = cards.duplicate(false)
	shuffled.shuffle()
	
	while len(shuffled) > DISCARD_OPTIONS:
		shuffled.pop_back()
	
	$"CardDeck menu".update(shuffled, 0)
	for card in $"CardDeck menu".get_children():
		card.connect("clicked", card_choice_callback) # Once you click a card, it calls the function passed in
