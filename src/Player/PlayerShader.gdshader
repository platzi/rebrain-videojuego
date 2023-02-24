shader_type canvas_item;

const float SPEED = 10.0;

uniform bool blocked;
uniform bool blink;
uniform vec4 BLACK : hint_color;
uniform vec4 SKIN_COLOR : hint_color;
uniform vec4 SHIRT_COLOR : hint_color;
uniform vec4 PANTS_COLOR : hint_color;
uniform vec4 SHOES_COLOR : hint_color;

void fragment() {
	vec4 referenceColor[13];
	referenceColor[0] = BLACK;
	referenceColor[1] = SKIN_COLOR * 0.2;
	referenceColor[2] = SKIN_COLOR * 0.8;
	referenceColor[3] = SKIN_COLOR;
	referenceColor[4] = SHIRT_COLOR * 0.2;
	referenceColor[5] = SHIRT_COLOR * 0.8;
	referenceColor[6] = SHIRT_COLOR;
	referenceColor[7] = PANTS_COLOR * 0.2;
	referenceColor[8] = PANTS_COLOR * 0.8;
	referenceColor[9] = PANTS_COLOR;
	referenceColor[10] = SHOES_COLOR * 0.2;
	referenceColor[11] = SHOES_COLOR * 0.8;
	referenceColor[12] = SHOES_COLOR;
	
	vec2 uv = UV;
	vec4 color = texture(TEXTURE, uv);
	int idx = int(floor(color.r * 19.0));
	for (int i=0; i<13; i++) {
		if (idx == i) {
			color.rgb = referenceColor[i].rgb;
			break;
		}
	}
	if (blocked) {
		color.r += 0.5 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
		color.a *= 0.2;
	}
	else if (blink) {
		color.g += 0.2 + step((sin(TIME * -SPEED + (uv.y / TEXTURE_PIXEL_SIZE.y) * 0.5) / 2.0) + 0.5, 0.2) * 0.2;
	}
	COLOR = color;
}
