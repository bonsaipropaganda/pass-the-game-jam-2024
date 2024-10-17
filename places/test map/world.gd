class_name World extends Node2D

func _ready() -> void:
	Ref.world = self
	Constructor.swap_map(Constructor.TEST_MAP, 0.5)
	

var selected_entity:Entity
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_right_click"):
		var click_coord:Vector2i = Utils.global_pos_to_coord(get_global_mouse_position())
		
		if Global.is_wall(click_coord): Global.get_terrain(click_coord).update_terrain_type(E.TerrainType.FLOOR)
		elif Global.is_floor(click_coord): Global.get_terrain(click_coord).update_terrain_type(E.TerrainType.PIT)
		elif Global.is_pit(click_coord): Global.get_terrain(click_coord).update_terrain_type(E.TerrainType.WALL)
	
	
	if Input.is_action_just_released("debug_click"):
		var click_coord:Vector2i = Utils.global_pos_to_coord(get_global_mouse_position())
		
		if selected_entity == null:
			if Global.coord_data(click_coord).has_entity():
				selected_entity = Global.coord_data(click_coord).entity
		
		
		else: ## elif selected_entity != null:
			if Global.coord_data(click_coord).has_entity():
				var swap_entity:Entity = Global.coord_data(click_coord).entity
				if swap_entity == selected_entity: selected_entity = null; return
				
				selected_entity.swap_with_occupied(swap_entity.global_coord)
				selected_entity = null
			
			else: ## no entity:
				if Global.coord_data(click_coord).terrain.type == E.TerrainType.FLOOR:
					selected_entity.move_to_free(click_coord)
					selected_entity = null
				else: selected_entity = null
