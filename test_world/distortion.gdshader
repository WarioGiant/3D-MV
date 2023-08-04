shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled;

uniform float strength = 0.025;

uniform sampler2D noise;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

global uniform vec3 PLAYER_BODY_GLOBAL_POSITION;

float linear_depth(sampler2D tex, vec2 uv, mat4 inv_proj_mat) {
	float depth = textureLod(tex, uv, 0.0).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj_mat * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void fragment() {
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec4 noise_sample = (textureLod(noise, (world_pos).xz * 0.025 + vec2(TIME * 0.015, TIME * 0.015), 0.0) * 2.0 - 1.0) * strength;
	vec2 distorted_screen_uv = SCREEN_UV + vec2(noise_sample.x, noise_sample.y);
	
	float screen_depth = linear_depth(depth_texture, SCREEN_UV, INV_PROJECTION_MATRIX);
	float distorted_screen_depth = linear_depth(depth_texture, distorted_screen_uv, INV_PROJECTION_MATRIX);
	
	
	
	vec2 uv = mix(distorted_screen_uv, SCREEN_UV, float((screen_depth - distorted_screen_depth >= 2.0)));
	
	ALBEDO = texture(screen_texture, uv).rgb;
}