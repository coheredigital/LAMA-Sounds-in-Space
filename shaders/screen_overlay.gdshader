shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_amount : hint_range(-2.0, 10.0) = 0.0;
uniform float mix_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color_over : source_color = vec4(0.0,0.0,0.0,1.0);

void fragment()
{
	vec2 uv = UV;
	vec3 output_color;
	vec4 screen_blurred = textureLod(screen_texture, uv, blur_amount);
	
	output_color = screen_blurred.rgb;
	output_color = mix(output_color.rgb,color_over.rgb,mix_amount);
	
	COLOR.rgb = output_color;
}
