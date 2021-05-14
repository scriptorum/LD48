
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
	fallDist = MAX_SPEED;
else
	fallDist = distance_to_object(ground) - 1 - vfloat;


if(fallDist == 0) {
	switch(sprite_index) {
		case sprPilgrimIdle:
			if(irandom(CHANCE_FIDGET) == 0) {
				sprite_index = sprPilgrimFidget;
			}
		break;
		
		case sprPilgrimFidget:
			if(image_index > image_number - 1) {
				sprite_index = sprPilgrimIdle;
			}
		break;
	}
}


// Nope
if(abs(fallDist) < MIN_FALL_DIST) {
	vspeed = 0;
	y = round(y + fallDist);
	return;
}	

if(vspeed < MIN_FALL_DIST) vspeed = MIN_FALL_DIST;
else vspeed = min(fallDist - 1, vspeed * BLOCK_ACCELERATION);


