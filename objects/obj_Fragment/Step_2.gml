#macro JITTER 3
#macro HALF_JITTER 2

if drawLight
{
	var jitterX = random(JITTER) - HALF_JITTER;
	var jitterY = random(JITTER) - HALF_JITTER;
	
	gpu_set_blendmode(bm_subtract);
	surface_set_target(global.light);
	draw_set_color(c_orange);
	draw_sprite(spr_Light, 0, x + sprite_width / 2 + jitterX, y + sprite_height / 2 + jitterY);
	draw_set_color(c_white);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}
