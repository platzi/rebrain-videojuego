shader_type canvas_item;

uniform bool blink;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (blink) {
		COLOR.rgb += vec3(1.0, 1.0, 1.0) * ((1.0 + sin(TIME * 15.0)) / 2.0);
	}
}