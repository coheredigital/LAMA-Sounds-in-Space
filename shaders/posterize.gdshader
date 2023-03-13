shader_type canvas_item;



uniform float levels : hint_range(1.0, 64.0, 1.0) = 16.0;



void fragment() 
{



	vec2 screen_size = vec2(textureSize(TEXTURE,0));
	vec4 screen = texture(TEXTURE, UV);

	vec2 size = vec2(textureSize(TEXTURE, 0));

	vec4 output_color = screen;
	float greyscale = max(output_color.r, max(output_color.g, output_color.b));
	float lower     = floor(greyscale * levels) / levels;
	float lower_diff = abs(greyscale - lower);
	float upper     = ceil(greyscale * levels) / levels;
	float upper_diff = abs(upper - greyscale);
	float level      = lower_diff <= upper_diff ? lower : upper;
	float adjustment = level / greyscale;
	output_color.rgb = output_color.rgb * adjustment;
	
	COLOR = output_color;
}