# A CardResource contains the data for a single card in the player's deck
# This should be inherited by all other cards
extends Resource
class_name CardResource

var card_name : String
var description : String
var action_count : int


# Returned positions are relative to where the player is
# Positions indicate where a card allows you to move/attack
func get_available_positions(player_pos:Vector2i) -> Array[Vector2i]:
	return []


# Return whether action succeeded
func do_move_action() -> bool:
	return true


# Return whether action succeeded
func do_attack_action() -> bool:
	return true


func on_discard() -> void:
	pass
