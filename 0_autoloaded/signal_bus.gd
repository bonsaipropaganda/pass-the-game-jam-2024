extends Node ## class_name SignalBus (Autoloaded)

## Emitted whenever enemies/things other than the player can move
signal game_tick

## Emitted when an enemy dies, so the room can keep track of how many are left
signal enemy_died

## Emitted when an enemy is spawned so the room can keep track of how many are left
signal enemy_spawned

## Emitted when all enemies in room have been killed
signal room_complete

## Emitted when the room is exited and a new one needs to be loaded
signal next_level(level_type: E.RoomType)

## Emitted at runtime if the terrain is changed so that other terrain scenes can update their visuals
signal terrain_changed

## Emitted for game_manager to handle post-hit discarding 
signal player_takes_damage
