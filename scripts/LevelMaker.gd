class_name LevelMaker extends RefCounted



func make_floor(viewport_size: Vector2, num_steps: int = 500) -> Array[Vector2i]:
	var viewport_center = viewport_size/2
	var bottom_right = viewport_size
	var top_left = Vector2(0,0)
	var top_right = Vector2(viewport_size.x, 0)
	var bottom_left = Vector2(0, viewport_size.y)
	var floor_walkers: Array[FloorWalker] = [
		FloorWalker.new(viewport_size, viewport_center)] 
		#FloorWalker.new(viewport_size, top_left)]
		#FloorWalker.new(viewport_size, top_right),
		#FloorWalker.new(viewport_size, bottom_left)]
	var floor: Array[Vector2i] = [floor_walkers[0].position] # Starting value
	
	
	# Lets avoid floor walker collisions with a fancy lambda function
	var place_floor_tile = func(new_tile: Vector2i) -> bool:
		var idx = floor.bsearch(new_tile)
		if idx < floor.size():
			if floor[idx] == new_tile: return false
		floor.insert(idx, new_tile)
		return true
	
	# Step 1: Make the floor
	var step_count = 0
	while(step_count < num_steps):
		# for each floor walker we take a step and rotate it random
		for floor_walker in floor_walkers:
			var new_tile = floor_walker.step()
			place_floor_tile.call(new_tile)
			floor_walker.rotate(randi_range(0, 3))
		
		step_count += 1
	
	# Step 2: Replace floor tiles with loot
	
	# Step 3: Add enemies
	
	# Step 4: Add player

	return floor
