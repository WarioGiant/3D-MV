shader_type spatial;

render_mode alpha_to_coverage_and_one;


uniform sampler3D noise;
uniform sampler2D alpha_mask : filter_linear;
uniform vec3 albedo : source_color;
uniform float inflate : hint_range(0.0, 5.0, 0.1);
uniform float size : hint_range(0.0, 5.0, 0.1) = 1.0;

uniform vec3 wind_dir = vec3(1.0, 0.0, 0.0);
uniform float wind_speed : hint_range(0.0, 1.0, 0.01);
uniform float wind_size : hint_range(0.0, 1.0, 0.01);

void vertex() {
	vec3 wind = texture(noise, VERTEX + normalize(wind_dir) * TIME * (wind_speed/10.0)).xyz * wind_size;
	
	vec2 centered_uv = (UV * 2.0) - vec2(1.0, 1.0);
	centered_uv.y *= -1.0; // flip y axis

	vec4 aligned = (INV_VIEW_MATRIX * vec4(centered_uv, 0.0, 0.0));
	aligned = aligned * MODEL_MATRIX;
	
	vec3 scaled = normalize(aligned.xyz) * size;
	vec3 inflated = scaled + (NORMAL * inflate);
	VERTEX += wind;
	VERTEX += inflated;
}

void fragment() {
	ALPHA_HASH_SCALE = 0.7;
	ALBEDO = albedo;
	float alpha = texture(alpha_mask, UV).r;
	ALPHA = alpha;
}


