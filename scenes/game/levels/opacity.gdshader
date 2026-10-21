shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float opacity : hint_range(0.0, 1.0) = 0.25;

void fragment(){
	COLOR = color;
	if(distance(vec2(0.5), UV) > 0.5){
		COLOR.a = 0.0;
	} else {
		COLOR.a = opacity;
	}
}
