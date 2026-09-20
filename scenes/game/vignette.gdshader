shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float vignette_intensity : hint_range(0.0, 16.0) = 2.0;
uniform float vignette_curve : hint_range(0.0, 16.0) = 1.0;
uniform vec4 vignette_rgb : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment(){
	vec4 final_color = vignette_rgb;
	final_color.a = distance(UV, center) * pow(vignette_intensity, vignette_curve);
	COLOR = final_color;
}
