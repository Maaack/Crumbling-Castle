shader_type canvas_item;

uniform sampler2D input_texture: hint_default_black, filter_linear_mipmap, repeat_enable;
uniform float speed = 1.0;
uniform vec2 pivot = vec2(0.5, 0.5);
uniform float zoom = 0.25;
uniform float layer_zoom_mod = 1.0;
uniform int layers = 5;
uniform float normalization = 1.0;
uniform float normalization_scale = -0.01;
uniform float opacity = 0.5;

// Adjust UV per new scale and pivot
vec2 adj_uv(vec2 a_uv, float a_scale, vec2 a_pivot){
	return a_pivot + (a_uv - a_pivot) * pow(a_scale, -1.0);
}

void fragment() {
	COLOR = texture(input_texture, UV);
	for (int iter = 0; iter < layers; iter++){
		vec2 adjusted_uv = adj_uv(UV, 1.0 + (zoom * float(iter)), pivot);
		vec2 adjusted_vector = adjusted_uv - UV;
		vec2 pivot_vector = 1.0 / (UV - pivot);
		vec2 normalized_vector = normalize(pivot_vector) * float(iter) * normalization_scale;
		pivot_vector = mix(adjusted_vector, normalized_vector, normalization);
		vec4 sample_color = texture(input_texture, pivot_vector + UV);
		// float total_opacity = pow(opacity, float(iter));
		COLOR = mix(COLOR, sample_color, sample_color.a * pow(opacity, float(iter)));
	}
}
