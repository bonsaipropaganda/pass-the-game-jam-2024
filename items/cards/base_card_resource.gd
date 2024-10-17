## A CardResource contains the data for a single card in the player's deck
## This should be inherited by all other cards
class_name CardResource extends Resource

var card_name : String
var description : String

## Should return an array of GLOBAL coords
## central_coord will generally be the player's position
func get_valid_coords(_central_coord:Vector2i) -> Array[Vector2i]:
	breakpoint; return [] ## dummy interface

## perform this card's unique action(s) at the target_coord
func do_action(_target_coord:Vector2i) -> void:
	pass ## dummy interface

## perform this card's unique discard effects
func on_discard() -> void:
	pass ## dummy interface
