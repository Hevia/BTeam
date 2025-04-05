class_name LevelMaker extends RefCounted



func make_floor(viewport_size: Vector2, num_steps: int = 500) -> Dictionary:
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
		
	# Generation vars
	var floor: Array[Vector2i] = [floor_walkers[0].position] # Starting value
	var bedrock: Array[Vector2i] = []
	var player_pos: Vector2
	
	
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
	
	floor.sort()
	
	# Step 2: Make a rectangle of bedrock tiles around the floor
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	
	# Find the bounds of the floor
	for tile in floor:
		min_x = min(min_x, tile.x)
		min_y = min(min_y, tile.y)
		max_x = max(max_x, tile.x)
		max_y = max(max_y, tile.y)
	
	# Only create the bedrock rectangle if the floor has tiles
	if floor.size() > 0:
		# Create a rectangle of bedrock tiles around the floor
		# We'll go one tile out from the bounds
		for x in range(min_x - 1, max_x + 2):
			# Top edge
			bedrock.append(Vector2i(x, min_y - 1))
			# Bottom edge
			bedrock.append(Vector2i(x, max_y + 1))
		
		for y in range(min_y, max_y + 1):
			# Left edge
			bedrock.append(Vector2i(min_x - 1, y))
			# Right edge
			bedrock.append(Vector2i(max_x + 1, y))

	return {"floor_tiles": floor, "bedrock_tiles": bedrock, "player_spawn": player_pos}
