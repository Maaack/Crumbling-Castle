shader_type canvas_item;

uniform sampler2D input_texture: hint_default_black, filter_linear_mipmap, repeat_enable;
uniform vec2 zoom_center = vec2(0.5, 0.5);
uniform int layers = 5;
uniform float opacity = 0.5;
uniform float zoom = 0.25;
uniform float normalization: hint_range(0.0, 1.0) = 1.0;
uniform float normalized_scale: hint_range(-1.0, 1.0) = 0.01;

// Adjust UV per new scale and pivot
vec2 adj_uv(vec2 a_uv, float a_scale, vec2 a_pivot){
	return a_pivot + (a_uv - a_pivot) * pow(a_scale, -1.0);
}

void fragment() {
	COLOR = texture(input_texture, UV);
	for (int iter = 0; iter < layers; iter++){
		vec2 adjusted_uv = adj_uv(UV, 1.0 + (zoom * float(iter)), zoom_center);
		vec2 adjusted_vector = adjusted_uv - UV;
		vec2 zoom_vector = (zoom_center - UV);
		vec2 normalized_vector = normalize(zoom_vector) * float(iter) * normalized_scale;
		zoom_vector = mix(adjusted_vector, normalized_vector, normalization);
		vec4 sample_color = texture(input_texture, zoom_vector + UV);
		COLOR = mix(COLOR, sample_color, sample_color.a * pow(opacity, float(iter)));
	}
}
