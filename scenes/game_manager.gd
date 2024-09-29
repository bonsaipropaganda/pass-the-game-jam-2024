# This script maintains the overall game state that persists between individual rooms,
# as well as supporting most game logic not specific to individual entities
extends Node2D
class_name GameManager

const tile_hover_rect_packed = preload("res://scenes/ui/tile_hover_rect.tscn")

enum GameState {
	IDLE, # Don't do anything in _process() until state is changed again
	PLAYER_TURN,
	ENEMY_TURN,
}

var game_state := GameState.PLAYER_TURN

var available_rooms = {
	"area_dungeon" = [
		preload("res://scenes/rooms/test_room.tscn"),
	],
	"area_next" = [
		# ...
	]
}

var players_cards : Array[CardResource] = [
	CardKingBasic.new(),
]

var discarded_cards : Array[CardResource] = []

var selected_card : CardResource = players_cards[0]
var current_room : Node


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
	
	assert(get_player() != null, "There is no player in room " + current_room.name)


func _ready() -> void:
	var first_room = pop_random_room("area_dungeon")
	await load_room(first_room)
	
	# show_available_actions doesn't seem to work unless we wait for physics to settle..
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	change_game_state(GameState.PLAYER_TURN)


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

func _process(_delta: float) -> void:
	match game_state:
		GameState.IDLE:
			pass
		
		GameState.PLAYER_TURN:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					var mp = get_global_mouse_position()
					var vec = Vector2i(mp.x / Global.TILE_SIZE, mp.y / Global.TILE_SIZE)
					var p = get_player()

					if (vec in selected_card.get_available_positions(get_player_tile_pos())):
						change_game_state(GameState.IDLE)
						hide_available_actions()
						await p.move(vec)
						change_game_state(GameState.ENEMY_TURN)
		
		GameState.ENEMY_TURN:
			change_game_state(GameState.PLAYER_TURN)
			# TODO
