# Hello

This document aims to help you get started more quickly
Please try to update it when you make relevant changes


## Getting up to speed on what is in the game
- Click the show controls button to see the controls


## Art style guide (last updated on day 1)
- The window is 320x180, scaled up times 3
- The window in in canvas_items mode. This means you can place art at half pixels and it will render correctly. This is primarly to allow the text to render nicely at all font sizes, let's try to properly keep the pixel art aesthetic otherwise.
- As of day 1, the pixel art style generally involves giving things black outlines, and sprites are 16x16 to fit on the grid.
- You may find .aseprite source files to help edit existing art


## Code guide (last updated on day 1)
- All player and enemy actions are described by scripts that inherit `CardResource`
- Most game logic occurs in game_manager.tscn. It is responsible for picking random rooms to spawn as you progress.
- global.gd is a singleton that provides utility functions, as well as global signals. There is also a corresponsing scene that has UI and stuff.
- The grid is not stored as a data structure. We simply check what is in a tile using a collision test in global.gd

### How to add a new card (last updated on day 1)
- Copy one of the basic cards like CardBasicKnight
- Note it must inherit CardResource

### How to add a new room (last updated on day 4)
- create a new script that inherits from `BaseRoomGenerator`
- add that script to the `rooms` array in `game_manager.gd`
- the room is described by a `PackedByteArray` for the tilemap and a dictionary of scenes for things like the player, enemies, and doors
- you have to add the player and exit doors yourself!
- use a combination of tilemap terrains and manually building patterns to create the room

