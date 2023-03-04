shader_type spatial;
render_mode depth_draw_opaque, diffuse_toon, cull_disabled;

uniform float emission_energy : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D emission_texture : hint_default_black, filter_nearest;
const vec2 resolution = vec2(16.0,32.0);
const int pixel_size = 1;
uniform sampler2D waveform : hint_default_black, filter_nearest;
uniform sampler2D waveform_amp_curve : hint_default_white, filter_nearest;
uniform bool waveform_controlled = false;

const float screen_count = 16.0;
const float frame_count = 8.0;
uniform float screen_number : hint_range(1,16.0,1.0) = 1.0;
uniform float frame_number : hint_range(1.0,8.0,1.0) = 1.0;

float steppify(float value, int steps){
	float cuts = float(steps);
	value = round(value * cuts) / cuts;
	return value;
}

void fragment() {
	
	vec2 frame_size = vec2(1.0);
	frame_size.x /= screen_count;
	frame_size.y /= (frame_count);
		
	float frequency = UV.x / frame_size.x;
	
	vec2 offset;
	offset.x = frame_size.x * (screen_number - 1.0);
	
//	allow weaveform to override animations
	if(waveform_controlled) {
		
		float waveform_y = texture(waveform, vec2(0.4)).y;
		
//		special case for "talking head" screen
		if(screen_number == 6.0)  {
			
			float waveform_left = texture(waveform, vec2(0.3)).x;
			waveform_left = steppify(waveform_left, 8);
			float waveform_right = texture(waveform, vec2(0.7)).x;
			waveform_right = steppify(waveform_right, 8);
			
			float waveform_top;
			waveform_top = max(waveform_left, waveform_top);
			waveform_top = max(waveform_right, waveform_top);
			waveform_top = texture(waveform_amp_curve, vec2(waveform_top)).x; 
			
			float waveform_bottom = texture(waveform_amp_curve, vec2(waveform_y)).x; 
			float mouth_mask = step(frame_size.y * 0.57, UV.y);
			offset.y = mix(
				frame_size.y * round(mix(0.0,3.0,waveform_bottom)),
				frame_size.y * round(mix(0.0,3.0,waveform_top)),
				mouth_mask
			);	
		}
		else   {
			offset.y = frame_size.y * round(mix(0.0,8.0,waveform_y));	
		}
	}
	else {
		offset.y = frame_size.y * (frame_number - 1.0);	
	}
	
//	steppify offsets to prevent misaligned frames
	offset.y = steppify(offset.y,int(frame_count));
	vec2 uv = UV + offset;
	
	ROUGHNESS = 1.0;
	AO = 0.0;
	ALBEDO = texture(emission_texture, uv).rgb;
	EMISSION = texture(emission_texture, uv).rgb * emission_energy;
	ALPHA = texture(emission_texture, uv).a * alpha;
}
