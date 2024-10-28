extends Node2D
class_name ShopItem

@onready var coin_counter: Control = $CoinCounter

var price: int = 5
var card = [
	CardKnightBasic,
	CardPawnBasic,
	CardBishopBasic,
	CardRookBasic,
	CardPlanB
]

func _ready() -> void:
	coin_counter.amount = price
	if Global.game_manager.danger_level > 1:
		card.append(CardJester)

func buy() -> bool:
	if Global.game_manager.money >= price:
		Global.game_manager.money -= price
		Global.game_manager.add_card(card.pick_random().new())
		#$ChestSoundPlayer.play
		queue_free()
		return true
	else:
		# TODO: maybe some animation + sfx to inform that player don't have enough money
		printerr("Not enough money")
		return false
