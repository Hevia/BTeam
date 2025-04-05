class_name LevelMaker extends RefCounted



func make_floor(viewport_size: Vector2, num_floor_tiles: int = 300) -> Array[Vector2i]:
	var floor_walkers: Array[FloorWalker] = [FloorWalker.new(), FloorWalker.new()]
	var floor: Array[Vector2i] = [floor_walkers[0].position] # Starting value
	
	# 
	# Lets avoid floor walker collisions with a fancy lambda function
	var place_floor_tile = func(new_tile: Vector2i) -> bool:
		var idx = floor.bsearch(new_tile)
		if idx < floor.size():
			if floor[idx] == new_tile: return false
		floor.insert(idx, new_tile)
		return true

	while(floor.size() < num_floor_tiles):
		# for each floor walker we take a step and rotate it random
		for floor_walker in floor_walkers:
			var new_tile = floor_walker.step()
			place_floor_tile.call(new_tile)
			floor_walker.rotate(randi_range(0, 3))

	return floor
