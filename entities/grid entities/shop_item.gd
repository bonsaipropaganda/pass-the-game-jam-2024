extends Node2D
class_name ShopItem

@onready var coin_counter: Control = $CoinCounter

var price: int = 5
var card: CardResource = [
	CardKnightBasic,
	CardPawnBasic,
	CardBishopBasic,
	CardRookBasic,
	CardPlanB
].pick_random().new()

func _ready() -> void:
	coin_counter.amount = price

func buy() -> bool:
	if Global.game_manager.money >= price:
		Global.game_manager.money -= price
		Global.game_manager.add_card(card)
		#$ChestSoundPlayer.play
		queue_free()
		return true
	else:
		# TODO: maybe some animation + sfx to inform that player don't have enough money
		printerr("Not enough money")
		return false
