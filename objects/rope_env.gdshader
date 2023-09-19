shader_type canvas_item;

void fragment() {
	//COLOR = vec4(UV*100.0, 0, 1);
	//VERTEX = VERTEX / 2.0;
	COLOR = vec4(vec2(FRAGCOORD.a, FRAGCOORD.b) * TEXTURE_PIXEL_SIZE, 0, 1);
	//COLOR = vec4(1, 0, 1, 1);
}
