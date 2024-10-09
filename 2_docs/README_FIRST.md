# Hello

This document aims to help you get started more quickly
Please try to update it when you make relevant changes

#---------------------------------------------------------------------------------------------------
## DAY 8 NOTES (Este aka Crownie)
#---------------------------------------------------------------------------------------------------

Here are some quick info to help get faster whats going on :
	
	-> the game is top down, tile/turn/card -based. Cards let you move and attack according to different patterns, and taking damage make you discard one of them.
	-> As of now, the game implements 2 systems. The earliest implemented (with the card movement system kinda working) is the 'game_manager.tscn' scene. The latest one is the 'world.tscn' scene, instancing 'test_map.tscn' ; no card system for this one, but the ability to procedurally generate rooms and move / swap entities and the player.
	
	=> This is state of the game when I started my turn. I don't really understand everything that's going on, so I'll leave to the next devs (hopefully more experienced than me for this game genre) the choice of either focusing on one of the 2 current options, or merge them together. Considering I'm pretty inexperienced with this game style and don't wanna mess things up even more, I'm focusing my turn on adding input options and other small quality of life improvements. 
	
	Good luck !

#---------------------------------------------------------------------------------------------------
## DAY 11 NOTES (Wiktor aka TheWizzard)
#---------------------------------------------------------------------------------------------------
	Log: 
	-Added Enemies movement and attack logic
	-Chest logic 
	all logical ofc
	
	Important notes:
	-In my latest commit as I used all enemy classes to provide different movement systems it broke use of 'world.tscn'(Post Grid Refactor)
	as I strongly recomend you to checkout this - go to commit d637bd6
	then if you want to go around this you need to replace inheritance of enemy classes from "base_enemy" to "entity" and cut all its dependences

	sorry for all inconvinence 
	and most importantly have Fun!
#---------------------------------------------------------------------------------------------------
## DAY 5 NOTES (BricksParts)
#---------------------------------------------------------------------------------------------------
I wasn't able to get as much complete as I would have liked, despite my best efforts. My major goal was to refactor the project to make it easier to approach and use for future devs, since there were many aspects that were suboptimal, such as the grid system, which was using raycasts and the like in order to get data.
For a grid-based game of any serious complexity, this is a nightmare, not to mention that it makes it
very roundabout to utilize or understand.

I managed to create a completely seperate grid system, and was planning on porting over all of the previous game logic to the new system, but simply didn't have time. If you check Global.gd you will see many methods I added that hopefully will help a lot, should you decide to try to port over the features from the version prior to my commit. The new system should allow for far more complex game logic without too much exposed complexity.

#---------------------------------------------------------------------------------------------------
## Random Notes
#---------------------------------------------------------------------------------------------------
I did try to test stuff as I went, and I feel decently confident about the updated grid system.
I have some test logic in World.gd (prior to any changs you make you should be able to see the test
in action when opening and playing the game. left click on the entities and then another location to
move or swap the locations of the entities)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
You can enable/disable the script tab addon under project settings -> plugins -> script tabs (enabled)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Making new maps should hopefully be fairly straightforwards. (You can check test_map for a simple example)
To make and access a new map:

- create a new scene with the root node being an instance of map.tscn

- make sure its children are editable

- use the InitTerrainMap to paint the level layout. From left to right the tiles in the map represent:
		Floor
		Wall
		Pit
		bedrock (Unbreakable)
The idea was that any tile except for bedrock could hypothetically change into another state
during gameplay, but bedrock would confine the player and prevent out-of-bounds issues

- use the InitEntitiesMap to paint the level with possible enemy spawns (E), hero spawns (P),
and the exit door (X). Make sure that there are at least 3 hero spawn positions, one for each of the player's heroes

- Using the exported variables on the amp you can adjust the minimum and maximum number of enemy spawns,
as well as the composition of enemies in the exported enemy_composition resource

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
I intended to make a sort of map server, which could take various aspects of state to determine what
map to provide next. This way the game could start with simpler maps with fewer enemies to more complex
maps as the player progressed further. Alas I never had time to do this. At the end of the day it's
up to any future devs to figure out how they wish to handle the specifics of that

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Terrain is designed with the idea that it could be altered during gameplay. Further

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
I didn't have time to look too deeply into the card system




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
