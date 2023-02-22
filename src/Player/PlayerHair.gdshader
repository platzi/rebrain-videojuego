shader_type canvas_item;

const float SPEED = 10.0;

uniform bool blocked;
uniform bool blink;
uniform vec4 HAIR_COLOR : hint_color;

void fragment() {
	vec4 referenceColor[3];
	referenceColor[0] = HAIR_COLOR * 0.4;
	referenceColor[1] = HAIR_COLOR * 0.8;
	referenceColor[2] = HAIR_COLOR;
	
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, uv);
	int idx = int(floor(color.r * 4.0));
	for (int i=0; i<3; i++) {
		if (idx == i) {
			color.rgb = referenceColor[i].rgb;
			break;
		}
	}
	if (blocked) {
		color.r += 0.5 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
	}
	else if (blink) {
		color.g += 0.2 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
	}
	COLOR = color;
}
