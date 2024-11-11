## A CardResource contains the data for a single card in the player's deck
## This should be inherited by all other cards
class_name CardResource extends Resource

var card_name : String
var description : String

## Should return an array of GLOBAL coords
## central_coord will generally be the player's position
func get_valid_coords(central_coord:Vector2i) -> Array[Vector2i]:
	breakpoint; return [] ## dummy interface

## perform this card's unique action(s) at the target_coord
func do_action(tileCord:Vector2i) -> void:
	CardActions.end_turn()
	
	return

## perform this card's unique discard effects
func on_discard() -> void:
	pass ## dummy interface

class CardActions:
	
	static func can_kill_tile(tileCord:Vector2i,damage:int=1):
		return can_attack_tile(tileCord) and Global.get_enemy_at_tile(tileCord).hp <= damage
	
	static func can_attack_tile(tileCord:Vector2i):
		return Global.is_enemy_on_tile(tileCord)
	
	static func attack_tile(tileCord:Vector2i,damage:int=1):
		Global.game_manager.get_player().attack()
		Global.attack_enemy_at_tile(tileCord, damage)
	
	
	static func can_move_to_tile(tileCord:Vector2i):
		return Global.is_floor_tile(tileCord) and not (can_loot_tile(tileCord) or can_attack_tile(tileCord))
	
	static func move_to_tile(tileCord:Vector2i,target:Node2D = Global.game_manager.get_player()):
		await target.move(tileCord)
	
	
	static func can_loot_tile(tileCord:Vector2i):
		return Global.is_chest_on_tile(tileCord) or Global.is_shop_item_on_tile(tileCord)
	
	
	static func loot_tile(tileCord:Vector2i):
		if Global.is_chest_on_tile(tileCord):
			Global.open_chest(tileCord)
		
		elif Global.is_shop_item_on_tile(tileCord):
			if Global.buy_shop_item(tileCord):
				AudioManager.sfx_play(AudioManager.sfx_enum.MONEY, 0.2, -2.0)
	
	## Should Allow Promoting One Card Into Another
	static func promote():
		pass
	
	static func end_turn():
		Global.game_manager.change_game_state(Global.game_manager.GameState.ENEMY_TURN)
	
	## Functions To Handel Charging The Card
	
	## Functions To Handle Card Cooldowns
