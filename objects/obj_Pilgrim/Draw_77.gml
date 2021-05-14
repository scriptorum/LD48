#macro JITTER 3
#macro HALF_JITTER 2
#macro LIGHT_OFF_X 0
#macro LIGHT_OFF_Y 0

var jitterX = random(JITTER) - HALF_JITTER;
var jitterY = random(JITTER) - HALF_JITTER;
	
gpu_set_blendmode(bm_subtract);
surface_set_target(global.light);
draw_set_color(c_orange);
draw_sprite(spr_Light, 0, x + sprite_width / 2 + jitterX + LIGHT_OFF_X, 
	y + sprite_height / 2 + jitterY + LIGHT_OFF_Y);
draw_set_color(c_white);
gpu_set_blendmode(bm_normal);
surface_reset_target();
