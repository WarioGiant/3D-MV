shader_type spatial;

render_mode vertex_lighting, shadows_disabled;

uniform sampler2D alpha_mask : filter_nearest;
uniform vec3 albedo : source_color;
uniform float inflate : hint_range(0.0, 5.0, 0.1);
uniform float size : hint_range(0.0, 5.0, 0.1) = 1.0;

void vertex() {
	vec2 centered_uv = (UV * 2.0) - vec2(1.0, 1.0);
	centered_uv.y *= -1.0; // flip y axis

	vec4 aligned = (INV_VIEW_MATRIX * vec4(centered_uv, 0.0, 0.0));
	aligned = aligned * MODEL_MATRIX;
	
	vec3 scaled = normalize(aligned.xyz) * size;
	vec3 inflated = scaled + (NORMAL * inflate);
	VERTEX += inflated;
}

void fragment() {
	ALBEDO = albedo;
	ALPHA = texture(alpha_mask, UV).r;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}