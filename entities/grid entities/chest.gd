class_name Chest extends AnimatedSprite2D
const POSSIBLE_CARDS_COUNT = 5
var is_open = false

var card: CardResource = [
	CardKnightBasic,
	CardPawnBasic,
	CardBishopBasic,
	CardRookBasic,
	CardPlanB
].pick_random().new()

func open():
	if is_open == false:
		Global.game_manager.players_cards.append(card)
		Global.game_manager.selected_card = Global.game_manager.players_cards.back()
		Global.game_manager.refresh_card_deck()
		self.play("open")
		await animation_finished
	else:
		is_open = true
