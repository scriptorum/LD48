

function iterate(list, func) {	
	for (var i = 0; i < ds_list_size(list); ++i) {
	    method(list[|i], func);
	}
}
