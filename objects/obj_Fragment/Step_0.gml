switch(state) {
	case BlockState.bs_shuddering:
		state = BlockState.bs_shuddering_now;
		origX = x;
		origY = y;
		alarm_set(0, 60);
	break;
	
	case BlockState.bs_shuddering_now:
		x = origX + random_range(-1, 1);
		y = origY + random_range(-1, 1);
	break;

	case BlockState.bs_falling:  		
		// Stop shuddering
		x = origX;
		y = origY;
		
		// Remove from grid
		origGroup = grid[# grid_x, grid_y];
		grid[# grid_x, grid_y] = -1;
		
		// Fall
		direction = 270;		
		dropSpeed = 1;
		state = BlockState.bs_falling_now;
	break;
	
	case BlockState.bs_falling_now:
		dropSpeed *= 1.1;
		if dropSpeed > TILE_SIZE / 4
			dropSpeed = TILE_SIZE / 4;			
					
		if place_meeting(x, y + TILE_SIZE, obj_Collidable)
		{
			var row = floor(y /  TILE_SIZE) + 1;
			if row >= GRID_HEIGHT || grid[# grid_x, row] != -1
				state = BlockState.bs_landing;	
			else y += dropSpeed;
		}
		else
			y += dropSpeed;
	break;
	
	
	case BlockState.bs_landing:
		// Loud noise
		// Dust
		// Puritan collision check

		// Update grid			
		grid_y = floor(y / TILE_SIZE);
		grid[# grid_x, grid_y] = origGroup;

		// Settle block instance into proper location
		y = grid_y * TILE_SIZE;			
		
		// Return to static
		state = BlockState.bs_static;
	break;
	
}