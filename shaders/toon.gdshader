shader_type spatial;
render_mode  cull_disabled, specular_disabled;


uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform sampler2D diffuse_curve : hint_default_white, filter_nearest, repeat_disable;
uniform float specular : hint_range(0,1) = 0.5;
uniform float specular_amount : hint_range(0,1) = 0.5;
uniform float specular_smoothness : hint_range(0,1) = 0.05;

uniform float rim : hint_range(0,1) = 0.5;
uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_amount : hint_range(0,1) = 0.2;
uniform float rim_smoothness : hint_range(0.001,1.0) = 0.05;

uniform float metallic : hint_range(0,1) = 0.0;
uniform float roughness : hint_range(0,1) = 1.0;

// Emission from base code.
uniform vec4 emission : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float emission_energy : hint_range(0.0, 8.0) = 1.0;
uniform sampler2D emission_texture : hint_default_black, filter_nearest;
uniform bool use_alpha = false;


void fragment() {
	ROUGHNESS = roughness;
	METALLIC = metallic;
	EMISSION = (emission.rgb + texture(emission_texture, UV).rgb) * emission_energy * COLOR.rgb;
	ALBEDO = albedo.rgb * COLOR.rgb * texture(albedo_texture, UV).rgb;
	float alpha = texture(albedo_texture, UV).a;
	float alpha_scissor_threshold = 0.9;
	if (use_alpha) {
		alpha = texture(albedo_texture, UV).a;
		alpha_scissor_threshold = 0.1;
	}
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	
}


//
void light() {
	float spec_value = specular;
	float spec_gloss = pow(2.0, 8.0 * (1.0 - specular_amount));
	float spec_smooth = specular_smoothness ;
	float rim_value = rim;
	float rim_width = rim_amount;
	float rim_smooth = rim_smoothness;


	vec3 litness = texture(diffuse_curve, vec2(dot(LIGHT, NORMAL), 0.0)).rgb * ATTENUATION;
	DIFFUSE_LIGHT += LIGHT_COLOR  * litness;

//	float rim_dot = 1.0 - dot(NORMAL, VIEW);
//	float rim_threshold = pow((1.0 - rim_width), dot(LIGHT, NORMAL));
//	float rim_intensity = smoothstep(rim_threshold - rim_smooth/2.0, rim_threshold + rim_smooth/2.0, rim_dot);
//	SPECULAR_LIGHT += LIGHT_COLOR * rim_color.rgb * rim_value * rim_intensity * litness;
}


