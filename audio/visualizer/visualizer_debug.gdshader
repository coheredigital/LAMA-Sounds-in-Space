shader_type canvas_item;

const float PI = 3.14159265358979323846;

uniform sampler2D waveform : hint_default_black;


uniform float background_opacity : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform vec4 background_color : source_color = vec4(0.0,0.0,0.0,0.5);



float get_height_mask(float waveform_data, vec2 uv, float offset) {
	float height = 1.0- uv.y + offset;
	float height_mask = step (smoothstep(0.0,1.0,height),smoothstep(0.0,1.0,waveform_data));
	return height_mask;
}

float get_line_mask(float waveform_data, vec2 uv, float width) {
	float mask = 1.0;
	mask = mix(mask, 0.0, get_height_mask(waveform_data, uv, 0.0));
	mask = mix(mask, 1.0, get_height_mask(waveform_data, uv, width));
	return 1.0-mask;
}

void fragment() {
	float frequency = UV.x;
	vec4 waveform_data = texture(waveform, vec2(frequency));
	vec4 waveform_avg = textureLod(waveform, vec2(frequency), 1.0);
	float height_mask = get_height_mask(waveform_data.x, UV, 0.01);
	float x_line_mask = get_line_mask(waveform_data.x, UV, 0.01);
	float y_line_mask = get_line_mask(waveform_data.y, UV, 0.01);
	float z_line_mask = get_line_mask(waveform_data.z, UV, 0.01);
	float line_raw_mask = get_line_mask(waveform_data.a, UV, 0.01);
		
	vec4 output_color;
	output_color = background_color;
	output_color.rgb *= background_opacity;
	output_color.rgb = mix(output_color.rgb,vec3(1.0), line_raw_mask);
	
	vec4 line_color;
	line_color = mix(line_color,line_color + vec4(1.0,0.0,0.0, 1.0), x_line_mask);
	line_color = mix(line_color,line_color + vec4(0.0,1.0,0.0,1.0), y_line_mask);
	line_color = mix(line_color,line_color + vec4(0.0,0.0,1.0,1.0), z_line_mask);
//	line_color += mix(line_color,z_color, z_line_mask);
	

	COLOR = output_color + line_color;



}




