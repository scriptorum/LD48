#macro MAX_GROUP_SIZE 10
#macro GRID_WIDTH 20
#macro GRID_HEIGHT 16
#macro TILE_SIZE 16
	
global.neighbors = ds_list_create();
ds_list_add(neighbors, [-TILE_SIZE, 0]);
ds_list_add(neighbors, [+TILE_SIZE, 0]);
ds_list_add(neighbors, [0, +TILE_SIZE]);
ds_list_add(neighbors, [0, -TILE_SIZE]);

function generateRoom() 
{	
	var grid = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);	
	ds_grid_clear(grid, noone);

	var list = ds_list_create();
	var xx, yy;
	for(yy = 0; yy < GRID_HEIGHT; yy += 1)
		for(xx = 0; xx < GRID_WIDTH; xx += 1)
			if(xx > 3 || yy > 3) // Skip upper left corner
				ds_list_add(list, instance_create_layer(xx * TILE_SIZE, yy * TILE_SIZE, "Instances", obj_Fragment));
	ds_list_shuffle(list);

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
				if(otherGroup != noone && ds_list_size(otherGroup.members) < MAX_GROUP_SIZE)
				{					
					group = otherGroup; // Will join neighboring group
					break;	
				}
			}
		}
				
		// Didn't join neighbor, so will start new group
		if(group == noone) 
		{
			group = {
				color: make_color_hsv(random_range(20,60),random_range(64,256),random_range(64, 196)),
				members: ds_list_create()
			};
		}		
		
		// Join group
		variable_instance_set(insta, "group", group);
		ds_list_add(group.members, insta);
		insta.image_blend = group.color;
	}
}
