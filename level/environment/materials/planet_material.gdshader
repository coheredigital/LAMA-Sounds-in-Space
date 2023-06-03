shader_type spatial;
render_mode cull_disabled, specular_disabled, ambient_light_disabled;


uniform sampler2D albedo_texture : source_color;
uniform sampler2D color_gradient : hint_default_white, filter_nearest, repeat_disable;
global uniform sampler2D diffuse_curve : hint_default_white, filter_nearest, repeat_disable;
global uniform vec4 diffuse_color : source_color = vec4(0.5);
uniform float specular : hint_range(0.0,1.0) = 0.5;
uniform float specular_amount : hint_range(0.0,1.0) = 0.5;
uniform float specular_smoothness : hint_range(0.0,1.0) = 0.05;

uniform float wrap : hint_range(-2.0, 2.0) = 0.25;

uniform float rim : hint_range(0.0,1.0) = 0.5;
global uniform sampler2D rim_curve : hint_default_black, filter_nearest, repeat_disable;
global uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_amount : hint_range(0,1) = 0.2;
uniform float rim_smoothness : hint_range(0.001,1.0) = 0.05;

uniform float metallic : hint_range(0.0,1.0) = 0.0;
uniform float roughness : hint_range(0.0,1.0) = 1.0;

// Emission from base code.
uniform float emission_energy : hint_range(0.0, 2.0) = 1.0;

vec3 get_sphere_uv(vec2 uv){
	vec3 panorama_uv = vec3(0.0, 0.0, 1.0);
	float rot_y = uv.x * PI * 2.0;
	float rot_z = uv.y * PI;
	panorama_uv.x = sin(rot_z) * sin(rot_y);
	panorama_uv.y = cos(rot_z);
	panorama_uv.z = sin(rot_z) * cos(rot_y);
    return normalize(panorama_uv);
}

void fragment() {
	
	vec3 sphere_uv = get_sphere_uv(UV);
	float planet_poles_mask = pow(smoothstep(0.75,1.0,sphere_uv.y),3.0) + pow(smoothstep(-0.75,-1.0,sphere_uv.y),3.0);
	float planet_land_mask = texture(albedo_texture, UV).r;
	planet_land_mask = mix(0.0,0.9,smoothstep(0.1,0.8,planet_land_mask));
	planet_land_mask =	mix(planet_land_mask,0.9,planet_poles_mask);
	
	vec3 planet_albedo = texture(color_gradient, vec2(planet_land_mask)).rgb;
	
	ROUGHNESS = roughness;
	METALLIC = metallic;
	EMISSION = planet_albedo * emission_energy * COLOR.rgb;
	ALBEDO = COLOR.rgb * planet_albedo;

	float alpha = texture(albedo_texture, UV).a;
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = 0.1;
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


