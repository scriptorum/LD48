#macro HALF_JITTER 0.8

var addLight = function(color) 
{
	var jitterX = random_range(-HALF_JITTER, HALF_JITTER);
	var jitterY = random_range(-HALF_JITTER, HALF_JITTER);
	var scaler = random_range(0.22, .28);
	draw_sprite_ext(spr_Light, 0, x + sprite_width *.2 + jitterX, 
		y - sprite_height * .8 + jitterY, scaler, scaler, 0, color, 0.5);
};

gpu_set_blendmode(bm_subtract);
surface_set_target(global.light);

addLight(c_orange);
addLight(c_yellow);

gpu_set_blendmode(bm_normal);
surface_reset_target();

