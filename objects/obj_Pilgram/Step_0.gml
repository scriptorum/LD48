
if(dragging) {
	self.x = mouse_x;
	self.y = mouse_y;
	vspeed = 0;
	return;
}

// Are we falling?
var fallDist = 0;
var ground = collision_line(x, y, x, y + TILE_SIZE, obj_Collidable, false, true);
if(ground == noone)
	fallDist = TILE_SIZE;
else
	fallDist = distance_to_object(ground) - vfloat;

show_debug_message("FallDist:" + string(fallDist));


// Nope
if(fallDist < vfloat + MIN_FALL_DIST) {
	vspeed = 0;
	y = round(y);
	return;
}
	
	

if(vspeed < MIN_FALL_DIST) vspeed = MIN_FALL_DIST;
else vspeed = min(fallDist - 1, vspeed * BLOCK_ACCELERATION);


// Yep


/*



		
	{
	if(sprite_index != spr_PilgramBigFall)
		sprite_index = spr_PilgramBigFall;			
}
else {
	// Maybe falling, check distance to ground
	var fallDist = distance_to_object(ground) - vfloat;
	if(fallDist > BIG_FALL_DIST) {
		if(sprite_index != spr_PilgramBigFall)
			sprite_index = spr_PilgramBigFall;			
	}		
	else {
		if(fallDist >= MIN_FALL_DIST) {
			if(sprite_index != spr_PilgramSmallFall)
				sprite_index = spr_PilgramBigFall;			
		}
	}
}	
*/