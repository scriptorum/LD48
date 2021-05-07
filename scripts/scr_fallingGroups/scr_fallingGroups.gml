/*
global.fallingGroups = ds_map_create();

function addToFallingGroup(_group, _instance)
{
	var members;
	if(!ds_map_exists(global.fallingGroups, _group))	
	{
		members = ds_list_create();
		ds_map_add(global.fallingGroups, _group, members);
	}
	else members = global.fallingGroups[? _group];
	
	ds_list_add(members, _instance);
}


function clearFallingGroup(_group)
{
	ds_map_delete(global.fallingGroups, _group);
}

function getFallingGroupMembers(_group)
{
	if(!ds_map_exists(global.fallingGroups, _group))	
		return undefined;
	return global.fallingGroups[? _group];
}

*/


//GroupBlock = function(_groupNumber) constructor
//{
//	groupNumber = _groupNumber;
//	members = ds_create_list();
//	add = function(_instance)
//	{
//		ds_list_add(members, _instance);
//		_instance.groupblock = self;
//	}
//}