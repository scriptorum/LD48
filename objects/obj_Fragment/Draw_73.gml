if grid != -1
{
	global.grid = grid;
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
			
            if neighbor != groupNumber {
				var col1 = $888888;
				var col2 = $AAAAAA;
				var hw = (x2 - x1) / 2 + x + x1;
				var hh = (y2 - y1) / 2 + y + y1;
                draw_line_width_colour(x+x1, y+y1, hw, hh, 1, col1, col2);
                draw_line_width_colour(hw, hh, x+x2, y+y2, 1, col2, col1);
			}
        }

		var maxx = sprite_width;
		var maxy = sprite_height;
		
		foo(groupNumber, 0, -1, 0, 0, maxx, 0);
		foo(groupNumber, 0, 1, 0, maxy, maxx, maxy);
		foo(groupNumber, -1, 0, 0, 0, 0, maxy);
		foo(groupNumber, 1, 0, maxx, 0, maxx, maxy);
		
		var bsColor= c_white;
		switch(state)
		{
			case BlockState.bs_shuddering: bsColor = c_navy; break;
			case BlockState.bs_shuddering_now: bsColor = c_blue; break;
			case BlockState.bs_falling: bsColor = c_maroon; break;
			case BlockState.bs_falling_now: bsColor = c_red; break;
			case BlockState.bs_landing: bsColor = c_yellow; break;
		}

		draw_set_color(bsColor);
		draw_text(x, y, groupNumber);
		draw_set_color(c_white);
	}
}