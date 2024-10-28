# Hello

This document aims to help you get started more quickly
Please try to update it when you make relevant changes

#---------------------------------------------------------------------------------------------------
## DAY 30 NOTES (Kaizar Nike)
#---------------------------------------------------------------------------------------------------

SO FAR: 10/28/24 - 9:00 AM, 4 Hours In
Watched the Joe Rogan Trump cast, what a real spectacle they are.
Otherwise:
	1: Gave game an icon
	2: Changed some git fiddly bits, I'm not sure if its important
	3: Added game over text, maybe you'll want to add more
	4: Identified 2 crashes, 2 glitches, and an annoyance, they are:
		- crash on show_available_actions() in game_manager.gd
		- crash on some tweening thing for sfx
		- glitch with level gen and background, temp fix by changing default clear color
		- glitch with level gen and walls, haven't fixed, need like 12 more tiles for one wide walls
		- annoyance: kinda would like to see where enemies will move next, unless that's part of the game
		
12 PM, 7 Hours In
Princesses for a royal dynasty

2 PM, 9 Hours In
Jesters for Ultimate Traversal (may need balancing)
Plus reworked enemy animations.

#---------------------------------------------------------------------------------------------------
## DAY 24 NOTES (Khusheete)
#---------------------------------------------------------------------------------------------------

QUICKSTART:
Here are a few interesting things you can find in this file:
- At the end of the file there are some infos about the game
- DAY 14: Geazas explains a lot about how the game works (this WILL be usefull to fix some bugs
  related to the procedural generation)

If you want to modify some visuals, there are lots of sprite already there in the game files
(res://gfx/**), maybe you'll find what you need.


Log:
- Added a more polished credits screen (for both participants of the jam and for external assets)	# TY, i liek - Kaizar
  -> See: res://3_credits
- Added some custom sprites and generally improved UI (added a custom button script
  that updates text color and plays a sfx when the button is hoverd)
- Made so the cards go down when they are not hovered
- Replaced placeholder coin sprites (custom made)
- Added animation and improved sfx for the door (the sprites were there already)
- Removed experiments from the game (damage test and funky grid refactor)
- - The damage test button served its debug duty well and had to take it's retirement o7
- - The "funky grid refactor" was a failed experiment (those are not my words).
	It's lifetime had sadly expired a few days ago, so I let it have the rest it deserved
- Made audio controls linear (it was exp scale, which made it hard to use)
- Ofc a lot of bug smashing occurred :)


#---------------------------------------------------------------------------------------------------
## DAY 22 NOTES (bonsaipropaganda)
#---------------------------------------------------------------------------------------------------

Log:
- Couldn't find any major game breaking bugs.
- added player death screen.
- added spikes
- increased difficulty slowly by increasing the "danger level" and causing that to spawn more enemies after 7 rooms
- added a coin grid entity that can be added to any room
- added a coin room for that coin grid entity

pro tip: the game_manager scene is where all the action is.


#---------------------------------------------------------------------------------------------------
## DAY 21 NOTES (Ohhnyx)
#---------------------------------------------------------------------------------------------------

//
IF YOU GET like 80 ERRORS AFTER CLONING THE PROJECT
reloading didn't work for me as others suggested,
what worked is clearing all the changes that were made automatically by
godot (import files and project file) and rebooting the engine.
//

I created a small audio management system.
You can find an example scene of it in the docs folder.
it should cover your needs. If it doesn't, you can either modify it or not use it!
if you don't use it, please still set up your audiostreamplayers to output in the correct audio bus.

I have refactored part of the scenes to use the sound system
(Careful not to break things if you try to do it to other existing scenes)
I also added a bunch of sfx. Change them if you want!

ALSO IF THE CLICK ON TILE HIVER IS ANNOYING -> player.gd line 29

Also added a splash screen, because why not?

This was really fun, thanks to the organizers and thanks to y'all fellow devs<3

BUGS FOUND AND A FEW IDEAS:
	- generation is sometimes broken. Had non-connected rooms and rooms with no door
	- seing what we're gonna buy in the shop would be nice. There's already a lot of random in the game
	- more enemies per room? pretty pleaaaaase?

#---------------------------------------------------------------------------------------------------
## Day 19 NOTES (Fusion)
#---------------------------------------------------------------------------------------------------

Bugs found:

- Knight jump into top right corner of starting room takes you to another room.
	This happens in other levels, when near the door, I think it might happen
	when the knight can move to the door.
	On second thought this may be intended functionality, I'm not sure.

- Bishop and rook (and others probably) can go through walls.	# I enjoyed doing the rook wallhack - Kaizar

- Cannot open chest with knight


#---------------------------------------------------------------------------------------------------
## DAY 14 NOTES (Geazas)
#---------------------------------------------------------------------------------------------------
	Some folks already write some details about the game below, but I think I can explain a bit more for a good start
	Tutorial:
	- On start, there's 'Normal' and 'Funky Grid refactor' button. Gameplay right now is on 'Normal' button
	- You start with King/Knight/Pawn cards, each card can make you move differently like chess move
	- You can move by selecting the card (using number keys or scroll) then click on the green marks
	- You start on the SPAWN room, the proceed to the MONEY room on exit
	- You will find monsters that can attack you, causing you to drop 1 card of your choice
	- You gain 1 random new card when opening a chest
	
	Notes:
	I find grid system to be complicated, even with the refactored one. I decided to continue with
	the pre-refactor grid system because integrating the refactored one with current gameplay will be quite hard.
	
	Explaination about (pre-refactored) grid system, which might save you some time
	- There are RoomGenerator classes, each of them can return RoomData when call `generate_room()`
	- RoomData has `tiles` which is 1D array but is representing a 2D map of tiles
		- ex. [1, 1, 1, 1, 1, 1] with room dimension Vect2i(3, 2) represents [[1, 1, 1], [1, 1, 1]]
		- each number represents diffrent tile, we have only 0,1 for floor and 17 for walls right now
	- Every room generation happens at `game_manager` at the function `to_next_level`
	- `game_manager` reads RoomData and generate a room starting on-top of the template `template_room.tscn`
	- It draws tiles at runtime on the tilemap inside `template_room.tscn` according to the data from `RoomData.tiles`
	- Then, it places scenes as the children of the tilemap from `RoomData.scenes`
	- `game_manager` determines the room dimension, unless overriden using `dim_override` in RoomData
	
	More notes:
	- If you got an error on start when opening the normal gameplay, try restart godot once.
	- There's inventory/item system which has some code but not implemented in the gameplay yet
	- GameManager is the 'god class' most game logic happens there
	- MONEY room is just room with Monsters, a Chest, and an Exit. Not room with money as the name suggests
	
	My contribution:
	- Added money system, money UI
	- Added shop item, when player click on it with enough money, a random card will be added to player deck
	- Added SPAWN room type and `castle_spawn_generator.gd`, change the initial room type from SHOP to SPAWN
	- Removed room's area logic for simpler code, we have only 1 area which is "castle" right now
	- Monster now drop 1 money on death
	
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
## DAY 8 NOTES (Este aka Crownie)
#---------------------------------------------------------------------------------------------------

Here are some quick info to help get faster whats going on :
	
	-> the game is top down, tile/turn/card -based. Cards let you move and attack according to different patterns, and taking damage make you discard one of them.
	-> As of now, the game implements 2 systems. The earliest implemented (with the card movement system kinda working) is the 'game_manager.tscn' scene. The latest one is the 'world.tscn' scene, instancing 'test_map.tscn' ; no card system for this one, but the ability to procedurally generate rooms and move / swap entities and the player.
	
	=> This is state of the game when I started my turn. I don't really understand everything that's going on, so I'll leave to the next devs (hopefully more experienced than me for this game genre) the choice of either focusing on one of the 2 current options, or merge them together. Considering I'm pretty inexperienced with this game style and don't wanna mess things up even more, I'm focusing my turn on adding input options and other small quality of life improvements. 
	
	Good luck !


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
