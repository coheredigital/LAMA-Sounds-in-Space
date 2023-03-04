shader_type canvas_item;

const float PI = 3.1415926535;

float steppify(float value, int steps){
	float cuts = float(steps);
	value = round(value * cuts) / cuts;
	return value;
}

float inverse_lerp(float start, float end, float value) {
	return (value - start) / (end - start);
}

float range_lerp(float value, float istart, float istop, float ostart, float ostop) {
	return mix(ostart,ostop, inverse_lerp(istart,istop,value));
}

float range_slerp(float value, float istart, float istop, float ostart, float ostop) {
	return mix(ostart,ostop, smoothstep(istart,istop,value));
}

vec3 rgb_to_hsv(vec3 rgb_color) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(rgb_color.bg, K.wz), vec4(rgb_color.gb, K.xy), step(rgb_color.b, rgb_color.g));
	vec4 q = mix(vec4(p.xyw, rgb_color.r), vec4(rgb_color.r, p.yzx), step(p.x, rgb_color.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),d / (q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 hsv_color) {
	vec3 c = hsv_color;
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float rgb_luminosity(vec3 rgb_color) {
	return ( 0.299 * rgb_color.r + 0.587 * rgb_color.g + 0.114 * rgb_color.b);
}


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
//	rotate sphere_uv 90 for better UV to vertex alignment
	return vec3(
		sphere_uv.x,
		sphere_uv.z * - 1.0,
		sphere_uv.y * - 1.0
	);
}

float linear_tween(float t, float b, float c, float d) {
	return c*t/d+b;
}


float slope_from_t (float t, float A, float B, float C){
  float dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C);
  return dtdx;
}

float x_from_t (float t, float A, float B, float C, float D){
  float x = A*(t*t*t) + B*(t*t) + C*t + D;
  return x;
}

float y_from_t (float t, float E, float F, float G, float H){
  float y = E*(t*t*t) + F*(t*t) + G*t + H;
  return y;
}

float cubic_bezier(float x, vec2 a, vec2 b){

	float y0a = 0.0; // initial y
	float x0a = 0.0; // initial x
	float y1a = a.y; 	// 1st influence y
	float x1a = a.x; 	// 1st influence x
	float y2a = b.y; 	// 2nd influence y
	float x2a = b.x; 	// 2nd influence x
	float y3a = 1.0; 		// final y
	float x3a = 1.0; 		// final x

	float A =   x3a - 3.0*x2a + 3.0*x1a - x0a;
	float B = 	3.0*x2a - 6.0*x1a + 3.0*x0a;
	float C = 	3.0*x1a - 3.0*x0a;
	float D =   x0a;

	float E =   y3a - 3.0*y2a + 3.0*y1a - y0a;
	float F = 	3.0*y2a - 6.0*y1a + 3.0*y0a;
	float G = 	3.0*y1a - 3.0*y0a;
	float H =   y0a;

	// Solve for t given x (using Newton-Raphelson), then solve for y given t.
	// Assume for the first guess that t = x.
	float current_t = x;
	for (int i=0; i < 5; i++){
		float current_x = x_from_t (current_t, A,B,C,D);
		float current_slope = slope_from_t (current_t, A,B,C);
		current_t -= ( current_x - x )*( current_slope);
		current_t = clamp(current_t, 0.0, 1.0);
	}

	float y = y_from_t (current_t,  E, F, G, H);
	return y;
}