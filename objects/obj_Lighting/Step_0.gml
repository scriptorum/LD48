surface_set_target(global.light);
draw_set_color(make_color_hsv(0,0,220));
draw_rectangle(0, 0, window_get_width(), window_get_height(), false);
surface_reset_target();

