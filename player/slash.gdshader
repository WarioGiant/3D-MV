shader_type spatial;

render_mode cull_disabled, unshaded, blend_add;

uniform sampler2D slash_texture : repeat_disable;
instance uniform float prog;

void fragment() {
	ALBEDO = texture(slash_texture, UV + vec2(0, prog)).rgb * 5.0;
	// Place fragment code here.
}
