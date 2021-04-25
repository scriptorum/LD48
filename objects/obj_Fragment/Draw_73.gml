if grid != -1
{
	var groupNumber = grid[# grid_x, grid_y];
	if !is_undefined(groupNumber)
	{
        foo = function(groupNumber, ox, oy, x1, y1, x2, y2) 
        {
			var neighbor = -1;
			var nx = grid_x + ox;
			var ny = grid_y + oy;
			if nx >= 0  && nx < GRID_WIDTH && ny >= 0 && ny < GRID_HEIGHT
				neighbor = grid[# nx, ny];
			
            if neighbor != groupNumber
                draw_line(x+x1, y+y1, x+x2, y+y2);
        }

		var maxx = sprite_width;
		var maxy = sprite_height;
		
		draw_set_color($88FFFFFF);
		foo(groupNumber, 0, -1, 0, 0, maxx, 0);
		foo(groupNumber, 0, 1, 0, maxy, maxx, maxy);
		foo(groupNumber, -1, 0, 0, 0, 0, maxy);
		foo(groupNumber, 1, 0, maxx, 0, maxx, maxy);
		draw_set_color($FFFFFFFF);
	}
}
