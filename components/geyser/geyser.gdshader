shader_type spatial;
render_mode shadows_disabled;

uniform vec3 color : source_color = vec3(0.2, 0.2, 0.2);

void fragment(){
	ALPHA = pow(COLOR.r, 0.5);
	ALBEDO = color;
	
}