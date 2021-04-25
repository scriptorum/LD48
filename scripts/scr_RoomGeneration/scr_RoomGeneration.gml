#macro MAX_GROUP_SIZE 10
#macro GRID_WIDTH 20
#macro GRID_HEIGHT 16
#macro TILE_SIZE 16
	
grid = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);
global.grid = grid;
global.maxGroupId = -1;

global.neighbors = ds_list_create();
ds_list_add(neighbors, [-1, 0]);
ds_list_add(neighbors, [+1, 0]);
ds_list_add(neighbors, [0, +1]);
ds_list_add(neighbors, [0, -1]);

function generateRoom() {
	var grid = global.grid;
	global.maxGroupId = -1;
	
	ds_grid_clear(grid, -1);

	var list = ds_list_create();
	var xx, yy;
	for(yy = 0; yy < GRID_HEIGHT; yy += 1)
		for(xx = 0; xx < GRID_WIDTH; xx += 1)
			ds_list_add(list, [xx,yy]);
	ds_list_shuffle(list);

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
		ds_list_shuffle(global.neighbors);
		for(var i = 0; i < 4; i += 1) {
			var nx = pos[0] + global.neighbors[|i][0];
			var ny = pos[1] + global.neighbors[|i][1];
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
			global.maxGroupId += 1;
			groupNumber = global.maxGroupId;
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

// Removes a block from the grid!
// You must remove the instance before/after calling this
function removeBlock(grid_x, grid_y) 
{
	var groupNumber = grid[# grid_x, grid_y];
	grid[# grid_x, grid_y] = -1;
	
	// Reassign other members of same group in case group split
	var groupsToCheck = reassign(groupNumber);
	
	// Always check the removed block's former group
	ds_list_add(groupsToCheck, groupNumber);
	
	// And check the cell above, if it's a different group
	if grid_y > 0
	{
		var groupAbove = grid[# grid_x, grid_y - 1];
		if groupAbove != -1 && is_undefined(ds_list_find_value(groupsToCheck, groupAbove))
			ds_list_add(groupsToCheck, groupAbove);
	}
	
	// For each group of concern, check if the group is falling
	for(var i =0; i <ds_list_size(groupsToCheck); i+= 1)
		checkGroupForFalling(groupsToCheck[|i]);
	
	ds_list_destroy(groupsToCheck);
}

// Checks to see if the group is falling
function checkGroupForFalling(groupNumber)
{
	var groupMembers = ds_list_create();	
	var falling = true;
	
	with(obj_Fragment)
	{
		var curGroup = grid[# grid_x, grid_y];
		if curGroup == groupNumber
		{
			ds_list_add(groupMembers, self);
			if grid_y < GRID_HEIGHT - 1
			{					
				var below = grid[# grid_x, grid_y + 1];
				if below != groupNumber && below != -1
					falling = false;									
			}
			else falling = false;
		}
	}
	
	if falling == true
	{
		for (var i = 0; i < ds_list_size(groupMembers); i += 1)			
			variable_instance_set(groupMembers[|i].id, "isFalling", true);
	}
}


// A fragment was removed, see if that fragment's group was split in half.
// Returns a list of group numbers that were added
function reassign(groupNumber) 
{		
	// Keep track of valid group numbers
	var ids = ds_list_create();
	ds_list_add(ids, groupNumber);
	
	
	// Create a list of fragments that are part of groupNumber
	// Unassign group for all these fragments (except first found)
	var list = ds_list_create();
	var xx, yy, skipFirstMember = true;
	for(yy = 0; yy < GRID_HEIGHT; yy += 1)
		for(xx = 0; xx < GRID_WIDTH; xx += 1)
		{
			if(grid[# xx, yy] == groupNumber)
			{
				if(skipFirstMember) 
					skipFirstMember = false;
				else 
				{
					grid[# xx, yy] = -1;
					ds_list_add(list, [xx,yy]);
				}
			}
		}
	
	// Go through this list and assign neighbors to group 1 or 2	
	var stepsSinceLastJoin = 0;
	while ds_list_size(list) > 0 
	{
		// Pop off a random position
		var pos = list[|0];
		ds_list_delete(list, 0);
		
		// Check all neighbors
		var neighborGroup = -1;
		for(var i = 0; i < 4; i += 1) {
			var nx = pos[0] + global.neighbors[|i][0];
			var ny = pos[1] + global.neighbors[|i][1];
			if nx < 0  || nx >= GRID_WIDTH || ny < 0 || ny >= GRID_HEIGHT
				neighborGroup = -2;
			else neighborGroup = grid[# nx, ny];
		
			// If neighbor has a valid group number, join it
			if ds_list_find_index(ids, neighborGroup) >= 0
			{				
				grid[# pos[0], pos[1]] = neighborGroup;
				stepsSinceLastJoin = 0;
			}
		}
		
		// If not assigned to neighboring group
		if grid[# pos[0], pos[1]] == -1
		{
			// Too many deferrals
			stepsSinceLastJoin += 1;
			if(stepsSinceLastJoin > ds_list_size(list))
			{
				// Join new group
				global.maxGroupId += 1;
				grid[# pos[0], pos[1]] = global.maxGroupId;
				ds_list_add(ids, global.maxGroupId);
				stepsSinceLastJoin = 0;
			}
				
			// Defer processing - move to end of list
			else ds_list_add(list, pos); 
		}
	}
	
	return ids;
}

