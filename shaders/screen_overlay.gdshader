shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D logo_texture : filter_nearest_mipmap;
uniform sampler2D loading_texture : filter_nearest_mipmap;
uniform float screen_blur_amount : hint_range(0.0, 10.0) = 0.0;
uniform float logo_blur_amount : hint_range(0.0, 10.0) = 0.0;
uniform float logo_alpha : hint_range(0.0, 1.0) = 0.0;
uniform float loading_blur_amount : hint_range(0.0, 10.0) = 0.0;
uniform float loading_alpha : hint_range(0.0, 1.0) = 0.0;
uniform float mix_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color_over : source_color = vec4(0.0,0.0,0.0,1.0);

void fragment()
{
	vec2 uv = UV;
	vec4 output_color;
	vec4 screen_color = textureLod(screen_texture, uv, screen_blur_amount);
	vec4 logo_color = textureLod(logo_texture, uv, logo_alpha);
	vec4 loading_color = textureLod(loading_texture, uv, loading_blur_amount);
		
	output_color = screen_color;
	output_color = mix(output_color,color_over,mix_amount);
	
//	mix in logo and loading screen

	output_color = mix(output_color,loading_color,loading_alpha * loading_color.a);
	output_color = mix(output_color,logo_color,logo_alpha * logo_color.a);
	
	COLOR.rgb = output_color.rgb;
}
