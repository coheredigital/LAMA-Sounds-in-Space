shader_type spatial;
render_mode depth_draw_opaque, diffuse_lambert, specular_disabled, cull_disabled;


const vec2 resolution = vec2(16.0,32.0);
uniform float emission_boost : hint_range(1.0,8.0) = 1.0;

uniform sampler2D waveform : hint_default_black;
uniform sampler2D gradient : source_color;
uniform sampler2D mask : hint_default_white, filter_nearest;

// lighting
uniform sampler2D emission_curve : hint_default_black;
uniform sampler2D equalizer_curve : hint_default_white;
uniform sampler2D opacity_curve : hint_default_white;


float steppify(float value, int steps){
	float cuts = float(steps);
	value = round(value * cuts) / cuts;
	return value;
}

void fragment() {
	vec2 uv = UV ;
	uv.x = steppify(uv.x, int(resolution.x));
	float frequency = uv.x;
	frequency = frequency * texture(equalizer_curve, vec2(frequency)).x;
	frequency = steppify(frequency, int(resolution.x));
	vec4 waveform_data = texture(waveform, vec2(frequency));
	float x_waveform = pow(waveform_data.x, 2.0);
	x_waveform = steppify(x_waveform, int(resolution.y));
	float y_waveform = pow(waveform_data.y, 2.0);
	y_waveform = steppify(y_waveform, int(resolution.y));
	float z_waveform = pow(waveform_data.z, 1.0);
	z_waveform = steppify(z_waveform, int(resolution.y));

	float emission_strength = texture(emission_curve,vec2(x_waveform)).x * emission_boost;
//	vec4 output_color = vec4(vec3(waveform_data.x, pow(waveform_data.x, 10.0), 1.0 - pow(waveform_data.x,20.0)),1.0);
//	white when the x value is more than the UV.y value
	float height_mask = step (smoothstep(0.5,0.0,1.0-uv.y),smoothstep(0.0,1.0,x_waveform)) * step (smoothstep(0.5,0.0,uv.y),smoothstep(0.0,1.0,x_waveform));
	
	vec4 output_color = texture(gradient,vec2(y_waveform ));
	
//	output_color = vec3(height_mask);
	
	ALBEDO = output_color.rgb;
	EMISSION = output_color.rgb * emission_strength * texture(mask,uv).x;
//	EMISSION = vec3(x_waveform);
//	EMISSION = vec3(texture(mask,uv).x);
	ALPHA = output_color.a * height_mask * texture(opacity_curve,uv).x * texture(mask,UV).x ;
//	ALPHA = height_mask ;
// 	ALPHA_SCISSOR_THRESHOLD = 0.9;
}




