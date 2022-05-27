shader_type canvas_item;

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
	
	vec4 textureColor = texture(TEXTURE, UV);
	int idx = int(floor(textureColor.r * 19.0));
	for (int i=0; i<13; i++) {
		if (idx == i) {
			COLOR.rgb = referenceColor[i].rgb;
			break;
		}
	}
	COLOR.a = textureColor.a;
}
