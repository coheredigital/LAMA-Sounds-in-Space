shader_type spatial;
render_mode cull_disabled, unshaded;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform sampler2D emission_gradient : hint_default_black, filter_nearest;


void fragment() {
//	setting max to 0.99 fixes an issue with progress on 1.0 uses first colour in gradient
	vec4 emission_gradient_rgba = texture(emission_gradient, vec2(min(progress,0.99),0.5));
	ALBEDO = emission_gradient_rgba.rgb * albedo.rgb;
	ALPHA = 1.0 - step(progress, UV.x);
	ALPHA_SCISSOR_THRESHOLD = 0.1;
}


