shader_type canvas_item;

uniform sampler2D image_texture : repeat_disable, filter_nearest_mipmap_anisotropic;

void fragment() {
	vec2 uv = UV;
	vec4 image = texture(image_texture, uv);
	COLOR.rgb = image.rgb;
}
