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
		Global.game_manager.add_card(card)

		self.play("open")
		await animation_finished
		is_open = true
