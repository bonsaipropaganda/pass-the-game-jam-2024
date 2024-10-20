extends Node ## class_name SignalBus (Autoloaded)

## Emitted whenever enemies/things other than the player can move
@warning_ignore("unused_signal")
signal game_tick

## Emitted when an enemy dies, so the room can keep track of how many are left
@warning_ignore("unused_signal")
signal enemy_died (enemy : BaseEnemy)

## Emitted when an enemy is spawned so the room can keep track of how many are left
@warning_ignore("unused_signal")
signal enemy_spawned (enemy : BaseEnemy)

## Emitted when all enemies in room have been killed
@warning_ignore("unused_signal")
signal room_complete

## Emitted when the room is exited and a new one needs to be loaded
@warning_ignore("unused_signal")
signal next_level(level_type: E.RoomType)

## Emitted at runtime if the terrain is changed so that other terrain scenes can update their visuals
@warning_ignore("unused_signal")
signal terrain_changed

## Emitted for game_manager to handle post-hit discarding 
@warning_ignore("unused_signal")
signal player_takes_damage

## Emitted when card_king_basic.gd _on_discard is called
@warning_ignore("unused_signal")
signal game_over
