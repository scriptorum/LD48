shudderOffsetX = 0;
shudderOffsetY = 0;
dropSpeed = 0;
lastState = -1;

enum BlockState {
	bs_static,
	bs_preshuddering,
	bs_shuddering,
	bs_falling,
	bs_landing,
	bs_wait
}

function changeState(newState) {
	lastState = state;
	state = newState;	
}