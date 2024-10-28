class_name Chest extends AnimatedSprite2D
const POSSIBLE_CARDS_COUNT = 5
var is_open = false

var card = [
	CardKnightBasic,
	CardPawnBasic,
	CardBishopBasic,
	CardRookBasic,
	CardPlanB
]

func open():
	if is_open == false:
		is_open = true
		if Global.game_manager.danger_level > 1:
			card.append(CardPrincessBasic)
		card = card.pick_random().new()
		Global.game_manager.add_card(card)
		$ChestSoundPlayer.play()

		self.play("open")
		await animation_finished
