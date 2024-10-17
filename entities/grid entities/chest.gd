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
		is_open = true

		Global.game_manager.add_card(card)
		$ChestSoundPlayer.play()

		self.play("open")
		await animation_finished
