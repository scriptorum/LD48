

function withlist(list, func) {	
	for (var i = 0; i < ds_list_size(list); ++i) {
		var obj = list[|i];
		if instance_exists(obj)
			with(obj)
			    method(obj, func);
	}
}
