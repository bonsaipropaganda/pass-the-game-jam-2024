## This is used for more than just the main deck, it displays cards in other UI also.
extends Control

signal card_selected(index: int)


const X_GAP = 30
const HAND_Y_MOVEMENT: float = 32.0


@export var card_scene : PackedScene
@export var hide_cards: bool = false


@onready var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var deck: Node2D = $Deck


var prev_selected_card := 0

var show_cards_tween: Tween
var show_cards: bool = false:
	set(value):
		if not is_inside_tree() or show_cards == value:
			return
		show_cards = value
		
		if show_cards_tween:
			show_cards_tween.kill()
		show_cards_tween = create_tween()
		
		var target_y_value: int
		if show_cards:
			target_y_value = -HAND_Y_MOVEMENT
		else:
			target_y_value = 0
		show_cards_tween.tween_property(deck, ^"position", Vector2(0.0, target_y_value), 0.2) \
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

var hovered_card_count: int = 0:
	set(value):
		hovered_card_count = max(value, 0)
		show_cards = hide_cards and (hovered_card_count != 0)


func get_cards() -> Array[CardUI]:
	var cards: Array[CardUI] = []
	for c: CardUI in deck.get_children():
		cards.push_back(c)
	return cards


## It is up to the game_manager to call this when needed
func update(cards:Array[CardResource], selected_card_index : int):
	var children = deck.get_children()

	var card_start_x = (scene_width / 2.0) - ((len(cards)-1.0) * (X_GAP) / 2.0)

	for i in len(cards):
		var card: CardUI 

		if len(children) > i:
			card = children[i]
		else:
			card = card_scene.instantiate()
			deck.add_child(card)
			card.clicked.connect(func(_x): card_selected.emit(i))
			card.mouse_entered.connect(func(): hovered_card_count += 1)
			card.mouse_exited.connect(func(): hovered_card_count -= 1)

		card.set_card_text(cards[i].card_name, cards[i].description)
		card.set_selected(i == selected_card_index)
		card.set_card_resource(cards[i])
		card.global_position.x = card_start_x + (i * X_GAP)
		if hide_cards:
			card.position.y = HAND_Y_MOVEMENT

	for i in range(len(cards), len(children)):
		if children[i].hovered:
			hovered_card_count -= 1
		children[i].queue_free()
