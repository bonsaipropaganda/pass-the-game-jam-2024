# This script maintains the overall game state that persists between individual rooms,
# as well as supporting most game logic not specific to individual entities
extends Node2D
class_name GameManager

const tile_hover_rect_packed = preload("res://scenes/ui/tile_hover_rect.tscn")
const ENEMY_HOVER_COLOR = Color("dd395264")
const FLOOR_HOVER_COLOR = Color("80f4a764")

enum GameState {
	BUSY, # Indicates not to do anything in _process()
	PLAYER_TURN,
	ENEMY_TURN,
}

var game_state := GameState.PLAYER_TURN

var available_rooms = {
	"area_dungeon" = [
		# Note - rooms are chosen by randomly popping from this list
		preload("res://scenes/rooms/test_room.tscn"),
		preload("res://scenes/rooms/template_room.tscn"),
	],
	"area_next" = [
		# ...
	]
}

var players_cards : Array[CardResource] = [
	CardKingBasic.new(),
	CardKnightBasic.new(),
	CardPawnBasic.new(),
]
var max_player_cards = 3 # Note - currently this doesn't do anything

var discarded_cards : Array[CardResource] = []

var selected_card : CardResource = players_cards[0] : set = set_selected_card
var current_room : Node


func _ready() -> void:
	$CanvasLayer/CardDeckUI.update(players_cards, selected_card)
	
	var first_room = pop_random_room("area_dungeon")
	await load_room(first_room)
	
	# show_available_actions doesn't seem to work unless we wait for physics to settle..
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	change_game_state(GameState.PLAYER_TURN)


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player")


func get_player_tile_pos() -> Vector2i:
	var p = get_player()
	assert(p)
	
	return Global.global_to_tile_position(p.global_position)


func pop_random_room(area_name:String) -> PackedScene:
	assert(area_name in available_rooms.keys(), "invalid area name!")
	assert(len(available_rooms[area_name]) > 0, "ran out of rooms for specified area!")
	
	var room_idx = randi_range(0, len(available_rooms[area_name]) - 1)
	return available_rooms[area_name].pop_at(room_idx)


func load_room(room:PackedScene) -> void:
	if current_room != null:
		current_room.queue_free()
	
	current_room = room.instantiate()
	add_child(current_room)
	
	var cam_limits = current_room.get_cam_limits()
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = cam_limits.x
	$Camera2D.limit_bottom = cam_limits.y
	$Camera2D.reset_smoothing()
	
	assert(get_player() != null, "There is no player in room " + current_room.name)


	# TODO this function is not complete
func get_valid_attack_positions() -> Array[Vector2i]:
	var ret:Array[Vector2i] = []
	for pos in selected_card.get_available_positions(Global.global_to_tile_position(get_player().global_position)):
		pass # TODO
	return ret


func hide_available_actions():
	for c in get_children():
		if c.is_in_group("hover_tile"):
			c.queue_free()


func show_available_actions():
	var player_pos = Global.global_to_tile_position(get_player().global_position)

	for tile_pos in selected_card.get_available_positions(player_pos):
		var rect = tile_hover_rect_packed.instantiate()
		
		if Global.is_enemy_on_tile(tile_pos):
			rect.color = ENEMY_HOVER_COLOR
		else:
			rect.color = FLOOR_HOVER_COLOR
		
		add_child(rect)
		rect.global_position = tile_pos * Global.TILE_SIZE


# Note - using explicit setter rather than gdscript setter for readability
func change_game_state(to:GameState):
	match to:
		GameState.PLAYER_TURN:
			show_available_actions()
		
		GameState.ENEMY_TURN:
			pass
	
	game_state = to


func set_selected_card(to):
	selected_card = to
	$CanvasLayer/CardDeckUI.update(players_cards, selected_card)
	
	# _process() will update this for us, doing it here will cause visual bug
	if game_state != GameState.BUSY:
		hide_available_actions()
		show_available_actions()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var num_pressed = event.keycode - KEY_0
			if num_pressed - 1 < len(players_cards):
				selected_card = players_cards[num_pressed - 1] # Calls setter


func _process(_delta: float) -> void:
	match game_state:
		GameState.BUSY:
			pass # Nothing happens here, something else is happening asynchronously
		
		GameState.PLAYER_TURN:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					var mp = get_global_mouse_position()
					var tile_pos = Vector2i(mp.x / Global.TILE_SIZE, mp.y / Global.TILE_SIZE)
					var p = get_player()

					if (tile_pos in selected_card.get_available_positions(get_player_tile_pos())):
						change_game_state(GameState.BUSY)
						hide_available_actions()
						if Global.is_enemy_on_tile(tile_pos):
							get_player().get_node("AnimationPlayer").play("attack")
							await Global.attack_enemy_at_tile(tile_pos, 1)
						else:
							await p.move(tile_pos)
						change_game_state(GameState.ENEMY_TURN)
		
		GameState.ENEMY_TURN:
			# TODO
			Global.emit_signal("game_tick")
			change_game_state(GameState.PLAYER_TURN)


func _on_test_damage_button_pressed() -> void:
	
	# Once we choose a card to discard, this lambda is called
	var card_choice_callback = func (card_choice:CardResource):
		card_choice.on_discard()
		players_cards.erase(card_choice)
		if len(players_cards):
			 # TODO - I'm not handling what happens if we discard the selected card, so I'm just ensuring you always select king after taking damage
			selected_card = players_cards[0]
		Global.fade_black(0, 0.5)
		$CanvasLayerFront/TakeDamageUI.visible = false
		get_tree().paused = false
	
	$CanvasLayerFront/TakeDamageUI.visible = true
	get_tree().paused = true
	Global.fade_black(0.6, 0.5)
	$CanvasLayerFront/TakeDamageUI.show_cards(players_cards, card_choice_callback)
