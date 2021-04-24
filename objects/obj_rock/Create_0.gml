
if attachedRock != -1
{	
	rockFixture = physics_fixture_create();		
	physics_fixture_set_collision_group(rockFixture, id);
	var radius = sprite_get_width(sprite_index) / 2;
	physics_fixture_set_circle_shape(rockFixture, radius);

physics_fixture_bind(rockFixture, id);
	physics_fixture_bind(rockFixture, attachedRock);
	show_debug_message("id:" + string(id) + " attached to:" + string(attachedRock) + " from " + string(x) + "," + string(y) + " to " + string(attachedRock.x) + "," + string(attachedRock.y));
	physics_joint_distance_create(id, attachedRock, x, y, attachedRock.x, attachedRock.y, false);
}




var r = random_range(128, 255);
image_blend = make_color_rgb(r,r,r);