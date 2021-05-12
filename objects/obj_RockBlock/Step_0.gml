#macro SHUDDER_SECONDS 1
#macro ADJACENT_DIST 2 // Should be larger than JITTER_EXTENT
#macro JITTER_EXTENT 1 

if(!instance_exists(self))
 var xasda = 10;

switch(state) {
	
	#region ************ bs_static ************************************************************************
	case BlockState.bs_static:
	var isFalling = true;
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		with(fragment) {
			var target = instance_place(x, y + ADJACENT_DIST, obj_Collidable);
			if(target == noone || target == self)
				lastVote = "v";	 // Rock falling
			else 
			{
				if (variable_instance_exists(target.id, "group") && target.group == other.id) 
					lastVote = "?";	
				else {
					lastVote = "-"; // Rock stuck
					isFalling = false; 
				}			
			}
		}
	}
	
	if(isFalling) {		
		changeState(BlockState.bs_shuddering);
		alarm_set(0, SHUDDER_SECONDS * game_get_speed(gamespeed_fps));
	}
	break;
	#endregion
	
	#region ************ bs_shuddering ********************************************************************
	case BlockState.bs_shuddering:
	var correctX = -shudderOffsetX;
	var correctY = -shudderOffsetY;
	shudderOffsetX = random_range(-JITTER_EXTENT, JITTER_EXTENT);
	shudderOffsetY = random_range(-JITTER_EXTENT, JITTER_EXTENT);
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		fragment.x += correctX + shudderOffsetX;
		fragment.y += correctY + shudderOffsetY;
	}
	break;
	#endregion
		
	#region ************ bs_falling ***********************************************************************
	case BlockState.bs_falling:
	//If coming from shuddering, stop shuddering now
	if(lastState == BlockState.bs_shuddering) {
		for (var i = 0; i < ds_list_size(members); ++i) {
			var fragment = members[|i];
			if(!instance_exists(fragment))
				continue;
			fragment.x += -shudderOffsetX;
			fragment.y += -shudderOffsetY;
		}
	}

	// Accelerate drop speed and check for collision
	dropSpeed = min(dropSpeed < 1 ? 1 : dropSpeed * 1.1, TILE_SIZE);
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		with(fragment)
		{
			var collider = instance_place(x, y + other.dropSpeed, obj_Collidable);			
			if(collider != noone)
				other.dropSpeed = min(other.dropSpeed, collider.bbox_top - bbox_bottom);
		}			
	}
	
	// If going very slowly, come to stop
	if(dropSpeed < 1.0) dropSpeed = 0;
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		else fragment.vspeed = dropSpeed;
	}
	
	// If stopped, switch to land state
	if(dropSpeed == 0)
		changeState(BlockState.bs_landing);
	break;
	#endregion
	
	#region ************ bs_landing ***********************************************************************
	case BlockState.bs_landing:
	dropSpeed = 0;
	show_debug_message("Boom");
	changeState(BlockState.bs_static);
	break;
	#endregion
}


lastState = state;