#macro SHUDDER_SECONDS 1
#macro JITTER_EXTENT 1 
#macro MIN_SPEED 1
#macro MAX_SPEED TILE_SIZE -1
#macro BLOCK_ACCELERATION 1.9

switch(state) {
	
	#region ************ bs_static ************************************************************************
	case BlockState.bs_static:
	var isFalling = true;
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		with(fragment) {
			var target = instance_place(x, y + MAX_SPEED, obj_Collidable);
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
	shudderX = random_range(-JITTER_EXTENT, JITTER_EXTENT);
	shudderY = random_range(-JITTER_EXTENT, JITTER_EXTENT);
	break;
	#endregion
		
	#region ************ bs_falling ***********************************************************************
	case BlockState.bs_falling:
	//If coming from shuddering, stop shuddering now
	if(lastState == BlockState.bs_shuddering) {
		shudderX = 0;
		shudderY = 0;
	}

	// Accelerate drop speed and check for collision
	dropSpeed *= BLOCK_ACCELERATION;
	dropSpeed = min(dropSpeed < MIN_SPEED ? MIN_SPEED : dropSpeed, MAX_SPEED);
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
	
	// Update all speeds of fragments making up this rock group
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		else fragment.vspeed = dropSpeed;
	}
	
	// If going very slowly, come to stop
	if(dropSpeed < MIN_SPEED) {
		dropSpeed = 0;
		changeState(BlockState.bs_landing);
	}
	break;
	#endregion
	
	#region ************ bs_landing ***********************************************************************
	case BlockState.bs_landing:
	dropSpeed = 0;
	
	// Zero out all speeds of fragments making up this rock group
	for (var i = 0; i < ds_list_size(members); ++i) {
		var fragment = members[|i];
		if(!instance_exists(fragment))
			continue;
		else fragment.vspeed = 0;
	}
	
	show_debug_message("Boom");
	changeState(BlockState.bs_static);
	break;
	#endregion
}


lastState = state;