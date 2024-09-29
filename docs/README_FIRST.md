# Hello

This document aims to help you get started more quickly
Please try to update it when you make relevant changes


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

### How to add a new room (last updated on day 1)
- Create a new scene
- Tick the little chain icon in the top left "Instantiate Child Scene" and select `scenes/rooms/template_room.tscn`
- Give your room a name, and save it in a folder appropriate to what area it belongs in
- If you want to place walls, select the wall tilemap layer and select the 'Terrain' tab
- The room has export variables that determine what enemies can spawn and stuff
    - Select desired min/max enemy count
    - Select the desired room size. Note you cannot make the room smaller than the default, as it is the minimum. Note a white rectangle in the editor will indicate the borders of the room.
    - There is a list of enemies that can spawn in the room. To add a new one, click the plus button, then drag the scene of an enemy from the filesystem dock into the new element you created.
- Place enemy spawners in the room
- Place exits in the room so the player can continue when they beat the room
- There is a list of rooms that will spawn in game_manager.tscn. Add your room to the list so it can appear during gameplay.
