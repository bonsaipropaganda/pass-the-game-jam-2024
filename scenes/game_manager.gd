## This script maintains the overall game state that persists between individual rooms,
## as well as supporting most game logic not specific to individual entities
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

# var available_rooms = {
# 	"area_dungeon" = [
# 		# Note - rooms are chosen by randomly popping from this list
# 		preload("res://scenes/rooms/test_room.tscn"),
# 	],
# 	"area_next" = [
# 		# ...
# 	]
# }

## this will be loaded and processed into room_generators in _ready
var rooms : Array[GDScript] = [
		preload("res://scenes/rooms/castle_shop_generator.gd"),
		preload("res://scenes/rooms/castle_boss_generator.gd"),
]
var room_generators := {}
var room_template := preload("res://scenes/rooms/template_room.tscn")
var curr_room_type := "castle"
var tileset_cache := {}

var players_cards : Array[CardResource] = [
	CardKingBasic.new(),
	CardKnightBasic.new(),
	CardPawnBasic.new(),
]
var max_player_cards = 3 # Note - currently this doesn't do anything

var discarded_cards : Array[CardResource] = []

var selected_card : CardResource = players_cards[0] : set = set_selected_card
var current_room : BaseRoom
# var current_area = available_rooms.keys()[0]


func _ready() -> void:
	for i: GDScript in rooms:
		var inst = i.new()
		assert(inst is BaseRoomGenerator, "all scrips assigned to rooms must inherit BaseRoomGenerator")
		
		if not room_generators.has(inst.get_area()):
			room_generators[inst.get_area()] = {
				Exit.ExitType.CARD_REWARD : [],
				Exit.ExitType.MONEY_REWARD : [],
				Exit.ExitType.BOSS : [],
				Exit.ExitType.SHOP : [],
			}
		
		room_generators[inst.get_area()][inst.get_type()].append(inst)
	
	$CanvasLayer/CardDeckUI.update(players_cards, selected_card)
	
	Global.next_level.connect(to_next_level)
	
	to_next_level(Exit.ExitType.SHOP) # Spawn in the initial level


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group("player")


func get_player_tile_pos() -> Vector2i:
	var p = get_player()
	assert(p)
	
	return Global.global_to_tile_position(p.global_position)


func to_next_level(exit_type: Exit.ExitType):
	var next_room : BaseRoomGenerator = room_generators[curr_room_type][exit_type].pick_random()
	var room_size := Vector2i(randi_range(25, 50), randi_range(25, 50))
	if room_size.y % 2 == 1:
		room_size.y += 1
	if room_size.x % 2 == 1:
		room_size.x += 1
	
	var room_data := next_room.generate_room(room_size, 1)
	if room_data.dim_override != Vector2i.ZERO:
		room_size = room_data.dim_override
	
	var used_tileset := next_room.get_used_tileset()
	var tileset_source : TileSetAtlasSource = used_tileset.get_source(0)

	if !tileset_cache.has(used_tileset):
		var id_to_tile := {}
		for i:int in tileset_source.get_tiles_count():
			var tile_data := tileset_source.get_tile_data(tileset_source.get_tile_id(i), 0)
			if tile_data and tile_data.get_custom_data("id") != 0:
				id_to_tile[tile_data.get_custom_data("id")] = tileset_source.get_tile_id(i)
		tileset_cache[used_tileset] = id_to_tile
	
	if current_room:
		current_room.queue_free()
	current_room = room_template.instantiate()
	add_child(current_room)
	current_room.tiles.tile_set = used_tileset

	var id_to_tile : Dictionary = tileset_cache[used_tileset]
	var all_coords : Array[Vector2i] = []
	for i: int in room_size.x * room_size.y:
		var coords := Vector2i(i % room_size.x, i / room_size.x)
		all_coords.append(coords)
		
		if room_data.tiles[i] != 0:
			current_room.tiles.set_cell(coords, 0, id_to_tile[room_data.tiles[i]])
			print(coords, id_to_tile[room_data.tiles[i]])
	
	for i in used_tileset.get_terrain_sets_count():
		for j in used_tileset.get_terrains_count(i):
			current_room.tiles.set_cells_terrain_connect(all_coords.filter(func(a: Vector2i)-> bool:
				var tile_data := current_room.tiles.get_cell_tile_data(a)
				if tile_data:
					if tile_data.terrain == j and tile_data.terrain_set == i:
						return true
				return false)
				, i, j)
	
	for i: Vector2i in room_data.scenes:
		var inst : Node = room_data.scenes[i]
		current_room.tiles.add_child(inst)
		inst.position = current_room.tiles.map_to_local(i)
	
	Global.room_complete.emit()

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
