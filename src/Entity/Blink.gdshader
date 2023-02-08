shader_type canvas_item;

uniform bool blink;

const float SPEED = 10.0;

void fragment() {
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, uv);
	if (blink) {
		color.g += 0.2 + step((sin(TIME * -SPEED + uv.y * 6000.0 * TEXTURE_PIXEL_SIZE.y) / 2.0) + 0.5, 0.2) * 0.2;
	}
	COLOR = color;
}