shader_type canvas_item;

uniform bool active = false;

void fragment(){
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 default_color = previous_color;
	vec4 white_color = vec4(1., 1., 1., previous_color.a);
	if (active) default_color = white_color;
	COLOR = default_color;
	
}