/*
	Dither Opacity Shader by Firerabbit
	
	MIT License
*/

shader_type spatial;

uniform sampler2D _albedo : source_color;
uniform vec4 color : source_color;
uniform float _alpha_clip : hint_range(0,1) = 0.01;

const vec4 dither[4] = {
	vec4(0.0625, 0.5625, 0.1875,  0.6875),
	vec4(0.8125, 0.3125, 0.9375,  0.4375),
	vec4(0.25, 0.75, 0.125, 0.625),
	vec4(1.0, 0.5, 0.875,  0.375)
};

float get_alpha_limit(int x, int y) {
	float res = 0.0;
	switch(y) {
		case 0:
			res = dither[x].r;
			break;
		case 1:
			res = dither[x].g;
			break;
		case 2:
			res = dither[x].b;
			break;
		case 3:
			res = dither[x].a;
			break;		
	}
	return res;
}

void fragment() {
//	vec4 color = texture(_albedo, UV);
	
	float alpha_limit = get_alpha_limit(int(FRAGCOORD.x) % 4, int(FRAGCOORD.y) % 4);
	
	if (color.a < alpha_limit || color.a < _alpha_clip) {
		discard;
	}
	ALBEDO = color.rgb;
}