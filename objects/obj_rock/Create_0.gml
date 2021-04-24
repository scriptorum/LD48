
if attachedRock != -1
{	
	var rockFixture = physics_fixture_create();		
	//var radius = sprite_get_width(sprite_index) / 2;
	physics_fixture_set_circle_shape(rockFixture, 1);

	physics_fixture_bind(rockFixture, id);
	physics_fixture_bind(rockFixture, attachedRock);
	
	var angle = 60 * rockAngle;
	var len = 8;
	var xx = lengthdir_x(len, angle);
	var yy = lengthdir_y(len, angle);
	
	//var angle = -point_direction(x, y, attachedRock.x, attachedRock.y);
	//var xx = (x + attachedRock.x) / 2;
	//var yy = (y + attachedRock.y) / 2;
	
	var joint = physics_joint_weld_create(id, attachedRock, xx, yy, degtorad(angle), 0, 1, false);
	
	show_debug_message("id:" + string(id) + " attached to:" + string(attachedRock) + " from " + string(x) + "," + string(y) + " to " + string(attachedRock.x) + "," + string(attachedRock.y)
		+ " Joint length is:" + string(physics_joint_get_value(joint, phy_joint_length_1))
		+ " and angle is: " + string(angle) + " and joing pos is " + string(xx) + "," + string(yy));
	
	physics_fixture_delete(rockFixture);	
}




var r = random_range(128, 255);
image_blend = make_color_rgb(r,r,r);
