shader_type canvas_item;


const float BLUR_STRENGTH = 0.15;
uniform int PIXEL_SIZE = 2;
uniform float levels : hint_range(1.0, 64.0, 1.0) = 16.0;



void fragment() 
{



	vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE,0));
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec2 size = vec2(textureSize(SCREEN_TEXTURE, 0));

	float xFactor = size.x / float(PIXEL_SIZE);
	float yFactor = size.y / float(PIXEL_SIZE);

	float grid_uv_x = round(SCREEN_UV.x * xFactor) / xFactor;
	float grid_uv_y = round(SCREEN_UV.y * yFactor) / yFactor;

	vec4 text = texture(SCREEN_TEXTURE, vec2(grid_uv_x, grid_uv_y));

	vec4 screen_blurred = textureLod(SCREEN_TEXTURE, vec2(grid_uv_x, grid_uv_y), BLUR_STRENGTH);

	vec4 output_color = screen_blurred;
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