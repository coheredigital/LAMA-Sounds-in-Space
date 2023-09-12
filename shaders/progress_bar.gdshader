shader_type spatial;
render_mode cull_disabled, specular_disabled, ambient_light_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;
global uniform sampler2D diffuse_curve : hint_default_white, filter_nearest, repeat_disable;
global uniform vec4 diffuse_color : source_color = vec4(0.5);


// Emission from base code.
uniform float emission_energy_min : hint_range(0.0, 8.0) = 1.0;
uniform float emission_energy_max : hint_range(0.0, 8.0) = 1.0;
uniform sampler2D emission_gradient : hint_default_black, filter_nearest;

void fragment() {
//	setting max to 0.99 fixes an issue with progress on 1.0 uses first colour in gradient
	vec4 emission_gradient_rgba = texture(emission_gradient, vec2(min(progress,0.99),0.5));
	EMISSION = emission_gradient_rgba.rgb * mix(emission_energy_max, emission_energy_min,  step(progress, UV.x));
	ALBEDO = albedo.rgb;
}


