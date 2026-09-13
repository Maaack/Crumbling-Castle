shader_type canvas_item;

uniform sampler2D input_texture: hint_default_black, filter_linear_mipmap, repeat_enable;
uniform float speed = 1.0;
uniform vec2 pivot = vec2(0.5, 0.5);
uniform float boarder_zoom = 2.0;

// Adjust UV per new scale and pivot
vec2 adj_uv(vec2 a_uv, float a_scale, vec2 a_pivot){
	return a_pivot + (a_uv - a_pivot) * pow(a_scale, -1.0);
}

// Returns [0, 0.999]
float normalized_float(float a_float){
	return float(int(10000.0 * a_float) % 10000) / 10000.0;
}

// Looping [0.0, 0.999] - used for building the different zoomed copies
float time_delta(){
	return normalized_float(TIME * speed);
}

// Here be all the goblins that get it all done
void fragment() {
	vec4 original_color = texture(input_texture, UV);
	vec4 sample_color = texture(input_texture, adj_uv(UV, boarder_zoom, pivot));
	COLOR = mix(original_color, sample_color, sample_color.a);
}
