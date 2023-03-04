shader_type spatial;
render_mode cull_front, shadows_disabled, diffuse_lambert_wrap, depth_draw_always;


const float PI = 3.14159265359;
const float STEPS_FACTOR = 8.0;
const float HORIZON_OFFSET = 0.05;
const vec2 NOISE_Z_OFFSET = vec2(0.317, 0.123);
const vec3 UP = vec3(0.0,1.0,0.0);

uniform sampler2D stars_texture : hint_default_black;
uniform vec4 ground_color : source_color = vec4(1.0, 0.7, 0.55, 1.0);
uniform vec4 horizon_color : source_color = vec4(1.0, 0.7, 0.55, 1.0);
uniform vec4 fog_color : source_color = vec4(0.3, 0.0, 0.3, 1.0);
uniform float fog_strength : hint_range(0.0,1.0) = 1.0;
uniform vec4 sky_color : source_color = vec4(1.0, 0.7, 0.55, 1.0);

uniform float stars_scale : hint_range(0.1,8.0) = 2.0;

uniform float stars_brightness : hint_range(0.0,8.0) = 2.0;
uniform float horizon_height : hint_range(-0.5,0.5) = 0.0;


vec3 get_sphere_uv(vec2 uv){
	vec3 panorama_uv = vec3(0.0, 0.0, 1.0);
	float rot_y = uv.x * PI * 2.0;
	float rot_z = uv.y * PI;
	panorama_uv.x = sin(rot_z) * sin(rot_y);
	panorama_uv.y = cos(rot_z);
	panorama_uv.z = sin(rot_z) * cos(rot_y);
    return normalize(panorama_uv);
}

vec3 rotate_sphere_uv(vec3 sphere_uv) {
//	rotate sphere_uv 90
	sphere_uv = vec3(
		sphere_uv.x,
		sphere_uv.z * - 1.0,
		sphere_uv.y 
	);
	return sphere_uv;
}

float steppify(float value, int steps){
	float cuts = float(steps);
	value = round(value * cuts) / cuts;
	return value;
}


float inverse_lerp(float start, float end, float value) {
	return clamp((value - start) / (end - start), 0.0, 1.0);
}


vec3 rotate_uv_x(vec2 uv,  vec3 panorama_uv) {
	float angle = -uv.y * PI / 2.0;
	float cos_angle = cos(angle); 
	float sin_angle = sin(angle);
	panorama_uv = panorama_uv * mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, cos_angle, -sin_angle),
		vec3(0.0, sin_angle, cos_angle)
	);
	return panorama_uv;
}


vec3 rotate_uv_y(vec2 uv,  vec3 panorama_uv) {
	float angle = -uv.x * PI;
	float cos_angle = cos(angle); 
	float sin_angle = sin(angle);
	return panorama_uv * mat3(
		vec3(cos_angle, 0.0, -sin_angle),
		vec3(0.0, 1.0, 0.0),
		vec3(sin_angle, 0.0, cos_angle)
	);
	return panorama_uv;
}



void fragment() {

	vec2 uv = UV;
	float emission_strength = 0.0;
	
	vec3 sphere_uv = get_sphere_uv(uv);	
	float horizon_offset = horizon_height + HORIZON_OFFSET;
//	MASKS ------------------------------------------------------------	

	float fog_mask = smoothstep(0.1 + horizon_offset,0.0 + horizon_offset,sphere_uv.y);	
	fog_mask = pow(fog_mask, 6.0);
	float horizon_mask = pow(smoothstep(0.7+horizon_offset,-0.2+horizon_offset,sphere_uv.y),2.75);
	float ground_mask = smoothstep(0.1 + horizon_offset,-0.056 + horizon_offset,sphere_uv.y);
	ground_mask = pow(ground_mask,1.0);
	
//	SKY: STARS ------------------------------
	vec3 stars_albedo = textureLod(stars_texture, uv.xy * stars_scale, 0.0).rgb;

	float stars_mask = textureLod(stars_texture, uv.xy * stars_scale, 0.0).b;
	stars_mask = mix(stars_mask,0.0,smoothstep(0.15 + horizon_offset,-0.15 + horizon_offset,sphere_uv.y));
	stars_mask = mix(stars_mask,0.0,smoothstep(0.15 + horizon_offset,-0.15 + horizon_offset,sphere_uv.y));
	stars_mask = clamp(stars_mask,0.0,1.0);
	
//	ALBEDO ------------------------------
	vec3 albedo = sky_color.rgb;	
	albedo = mix(albedo,horizon_color.rgb,horizon_mask);
	albedo = mix(albedo,fog_color.rgb,fog_mask);
	albedo = mix(albedo,ground_color.rgb,ground_mask);
	
	vec3 emission = vec3(0.0);
	emission = mix(albedo * 0.5, albedo, 1.0 - ground_mask);
	emission = mix(emission, vec3(stars_mask * stars_brightness), stars_mask * stars_brightness );

//	OUTPUT --------------------------------------
    ALBEDO = albedo;
	EMISSION = emission;

	
}