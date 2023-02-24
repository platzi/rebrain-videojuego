shader_type canvas_item;

uniform bool blocked;
uniform bool blink;

const float SPEED = 10.0;

void fragment() {
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, uv);
	if (blocked) {
		color.r += 0.5 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
		color.a *= 0.2;
	}
	else if (blink) {
		color.g += 0.2 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
	}
	COLOR = color;
}