// This overrides the draw event so apply a shuddering effect
// rather than actually moving the object, which interferes with 
// falling collisions
draw_sprite_ext(spr_fragment, 0, x + group.shudderX, y + group.shudderY, 1, 1, 0, group.color, 1);