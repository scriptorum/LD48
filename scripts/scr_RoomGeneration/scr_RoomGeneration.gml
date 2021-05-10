#macro MAX_GROUP_SIZE 10
#macro GRID_WIDTH 20
#macro GRID_HEIGHT 16
#macro TILE_SIZE 16

// Create neighbor shorthands
global.neighbors = ds_list_create();
ds_list_add(neighbors, [-TILE_SIZE, 0]);
ds_list_add(neighbors, [+TILE_SIZE, 0]);
ds_list_add(neighbors, [0, +TILE_SIZE]);
ds_list_add(neighbors, [0, -TILE_SIZE]);


function generateRoom() 
{	
	// Create grid of objects
	var list = ds_list_create();
	var xx, yy;
	for(yy = 0; yy < GRID_HEIGHT; yy += 1)
		for(xx = 0; xx < GRID_WIDTH; xx += 1)
			if(xx > 3 || yy > 3) // Skip upper left corner
				ds_list_add(list, instance_create_layer(xx * TILE_SIZE, yy * TILE_SIZE, "Instances", obj_Fragment));
	ds_list_shuffle(list);
	
	// Join neighboring objects
	joinNeighbors(list);

	// Cleanup
	ds_list_destroy(list);
}

// Pass a list of instances to check
// This list will be empty at the end
function joinNeighbors(list) 
{
	// Join neighboring objects
	while ds_list_size(list) > 0 
	{
		// Pop off a random position
		var insta = list[|0];
		ds_list_delete(list, 0);
	
		// Check all neighbors
		ds_list_shuffle(global.neighbors);
		var group = noone;
		for(var i = 0; i < 4; i += 1) 
		{
			var otherInsta = instance_position(insta.x + global.neighbors[|i][0], insta.y + global.neighbors[|i][1], obj_Fragment);
			if(otherInsta != noone) {
				var otherGroup = variable_instance_get(otherInsta, "group");
				var otherMembers = variable_instance_get(otherGroup, "members");
				if(otherGroup != noone && ds_list_size(otherMembers) < MAX_GROUP_SIZE)
				{					
					group = otherGroup; // Will join neighboring group
					break;	
				}
			}
		}
				
		// Didn't join neighbor, so will start new group
		if(group == noone) 
		{
			group = instance_create_layer(insta.x, insta.y, "Instances", obj_RockBlock);
			variable_instance_set(group, "color", make_color_hsv(random_range(20,60),random_range(64,256),random_range(64, 196)));
			variable_instance_set(group, "members", ds_list_create());
		}		
		
		// Join group
		var members = variable_instance_get(group, "members");
		ds_list_add(members, insta);
		variable_instance_set(insta, "group", group);
		insta.image_blend = variable_instance_get(group, "color");
	}
}

function removeFragment(obj) 
{
	// Remove fragment from world and group
	var mainGroup = variable_instance_get(obj, "group");
	var mainMembers = variable_instance_get(mainGroup, "members");
	ds_list_delete(mainMembers, ds_list_find_index(mainMembers, obj.id));
	instance_destroy(obj);

	// Give remaining fragments a unique group id
	var groupIds = ds_list_create();
	var groupInstances = ds_list_create();
	for(var i = 0; i < ds_list_size(mainMembers); i++) 
	{
		groupIds[|i] = i;
		groupInstances[|i] = noone;
	}
				
	// Compare each fragment to each other -- if neighbors, then share lower group id
	for(var i1 = 0; i1 < ds_list_size(mainMembers) - 1; i1++)
	for(var i2 = i1 + 1; i2 < ds_list_size(mainMembers); i2++)
	{
		if(i1 == i2) continue;
		if(groupIds[|i1] == groupIds[|i2]) continue;
		
		var insta1 = mainMembers[|i1];
		var insta2 = mainMembers[|i2];
		
		var dist = point_distance(insta1.x, insta1.y, insta2.x, insta2.y);
		if(abs(dist - TILE_SIZE) < 1)
		{
			if(groupIds[|i1] < groupIds[|i2])
				groupIds[|i2] = groupIds[|i1];
			else groupIds[|i1] = groupIds[|i2];
		}
	}	
	
	// Give each fragment a group matching their group id	
	for(var i = 0; i < ds_list_size(mainMembers); i++)
	{
		var insta1 = mainMembers[|i];
		var group = groupIds[|i];
		var groupInstance = groupInstances[|group];
		
		if(groupInstance == noone)
		{
			groupInstance = instance_create_layer(insta1.x, insta1.y, "Instances", obj_RockBlock);
			variable_instance_set(groupInstance, "color", variable_instance_get(mainGroup, "color"));
			variable_instance_set(groupInstance, "members", ds_list_create());
		}
		
		groupInstances[|i] = groupInstance;
		ds_list_add(variable_instance_get(groupInstance, "members"), insta1);
		variable_instance_set(insta1, "group", groupInstance);
	}
	
	// Delete unused data
	ds_list_destroy(groupInstances)	
	ds_list_destroy(groupIds)	
	ds_list_destroy(mainMembers)	
	delete mainGroup;
}




