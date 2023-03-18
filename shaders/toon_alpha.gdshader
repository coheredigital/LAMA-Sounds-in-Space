shader_type spatial;
render_mode diffuse_toon, specular_toon, shadows_disabled;


uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;
global uniform sampler2D diffuse_curve : hint_default_white, filter_nearest;
global uniform vec4 diffuse_color : source_color = vec4(0.5);
uniform float specular : hint_range(0,1) = 0.5;
uniform float specular_amount : hint_range(0,1) = 0.5;
uniform float specular_smoothness : hint_range(0,1) = 0.05;

uniform float rim : hint_range(0,1) = 0.5;
global uniform sampler2D rim_curve : hint_default_black, filter_nearest, repeat_disable;
global uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_amount : hint_range(0,1) = 0.2;
uniform float rim_smoothness : hint_range(0.001,1.0) = 0.05;

uniform float wrap : hint_range(-2.0, 2.0) = 0.32;

uniform float metallic : hint_range(0,1) = 0.0;
uniform float roughness : hint_range(0,1) = 1.0;

// Emission from base code.
uniform vec4 emission : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float emission_energy : hint_range(0.0, 2.0) = 1.0;
uniform sampler2D emission_texture : hint_default_black, filter_nearest;
uniform bool use_alpha = false;




void fragment() {
//	ROUGHNESS = roughness;
//	METALLIC = metallic;
	EMISSION = (emission.rgb + texture(emission_texture, UV).rgb) * emission_energy * COLOR.rgb;
	ALBEDO = albedo.rgb * COLOR.rgb * texture(albedo_texture, UV).rgb;
	ALPHA = texture(albedo_texture, UV).a;

	
}


//
void light() {
	float spec_value = specular;
	float spec_gloss = pow(2.0, 8.0 * (1.0 - specular_amount));
	float spec_smooth = specular_smoothness ;
	float rim_value = rim;
	float rim_width = rim_amount;
	float rim_smooth = rim_smoothness;

	// Diffuse lighting.
	float diffuse = dot(NORMAL, LIGHT) + wrap;
	vec3 litness = mix(vec3(1.0),texture(diffuse_curve, vec2(diffuse) ).rgb * diffuse_color.rgb, diffuse_color.a) * ATTENUATION;
	DIFFUSE_LIGHT += LIGHT_COLOR  * litness;

	float rim_dot = 1.0 - dot(NORMAL, VIEW);
	float rim_threshold = pow((1.0 - rim_width), dot(LIGHT, NORMAL));
	float rim_intensity = texture(rim_curve, vec2( smoothstep(rim_threshold - rim_smooth/2.0, rim_threshold + rim_smooth/2.0, rim_dot)) ).r   ;
	SPECULAR_LIGHT += LIGHT_COLOR * rim_color.rgb * rim_value * rim_intensity * litness;
}


