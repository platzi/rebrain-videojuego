shader_type canvas_item;

uniform float glow;
uniform vec4 HAIR_COLOR : hint_color;

void fragment() {
	vec4 referenceColor[3];
	referenceColor[0] = HAIR_COLOR * 0.4;
	referenceColor[1] = HAIR_COLOR * 0.8;
	referenceColor[2] = HAIR_COLOR;
	
	vec4 textureColor = texture(TEXTURE, UV);
	int idx = int(floor(textureColor.r * 4.0));
	for (int i=0; i<3; i++) {
		if (idx == i) {
			COLOR.rgb = referenceColor[i].rgb;
			break;
		}
	}
	COLOR.rgb += vec3(1.0) * glow;
	COLOR.a = textureColor.a;
}
