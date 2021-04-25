#macro MAX_GROUP_SIZE 10
#macro GRID_WIDTH 20
#macro GRID_HEIGHT 16
#macro TILE_SIZE 16


function generateRoom() {
	var maxGroupId = -1;
	var grid = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);

	ds_grid_clear(grid, -1);

	var list = ds_list_create();
	var xx, yy;
	for(yy = 0; yy < GRID_HEIGHT; yy += 1)
		for(xx = 0; xx < GRID_WIDTH; xx += 1)
			ds_list_add(list, [xx,yy]);
	ds_list_shuffle(list);

	var neighbors = ds_list_create();
	ds_list_add(neighbors, [-1, 0]);
	ds_list_add(neighbors, [+1, 0]);
	ds_list_add(neighbors, [0, +1]);
	ds_list_add(neighbors, [0, -1]);

	var groupSize = [], groupColor = [], groupNumber;
	while ds_list_size(list) > 0 
	{
		// Pop off a random position
		var pos = list[|0];
		ds_list_delete(list, 0);
	
		// Skip this position, it has already been processed
		if grid[# pos[0], pos[1]] != -1
			continue;		
	
		// Check all neighbors
		ds_list_shuffle(neighbors);
		for(var i = 0; i < 4; i += 1) {
			var nx = pos[0] + neighbors[|i][0];
			var ny = pos[1] + neighbors[|i][1];
			if nx < 0  || nx >= GRID_WIDTH || ny < 0 || ny >= GRID_HEIGHT
				groupNumber = -1;
			else groupNumber = grid[# nx, ny];
		
			// Look at this neighbor
			if groupNumber != -1 && groupSize[groupNumber] < MAX_GROUP_SIZE
			{
				// Join neighboring group
				groupSize[groupNumber] += 1;			
				break; // Leave for loop
			} 
			else groupNumber = -1;
		}
	
		// Didn't join neighbor, so start new group
		if groupNumber == -1 {
			maxGroupId += 1;
			groupNumber = maxGroupId;
			groupColor[groupNumber] = make_color_hsv(random_range(20,60),random_range(64,256),random_range(64, 196));
			groupSize[groupNumber] = 1;
		}
	
		// Create new fragment
		grid[# pos[0], pos[1]] = groupNumber; // Note fragment's group in grid
		var obj = instance_create_layer(pos[0] * TILE_SIZE, pos[1] * TILE_SIZE, "Instances", obj_Fragment);
		//show_debug_message("Created obj " + string(obj.id) + " at " + string(obj.x) + "," + string(obj.y) + " in group" + string(groupNumber));
		obj.image_blend = groupColor[groupNumber];
	
		// Store grid details so fragment can decorate itself
		obj.grid = grid;
		obj.grid_x = pos[0];
		obj.grid_y = pos[1];
	}
}
