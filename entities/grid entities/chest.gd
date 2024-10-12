class_name Chest extends AnimatedSprite2D
const POSSIBLE_CARDS_COUNT = 5

var card: CardResource = [
	CardKnightBasic,
	CardPawnBasic,
	CardBishopBasic,
	CardRookBasic,
	CardPlanB
].pick_random().new()

func open():
	Global.game_manager.players_cards.append(card)
	Global.game_manager.selected_card = Global.game_manager.players_cards.back()
	Global.game_manager.refresh_card_deck()
	queue_free()
