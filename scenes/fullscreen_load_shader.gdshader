shader_type canvas_item;
render_mode blend_mix;

uniform float grid_scale : hint_range(2.0, 60.0) = 20.0;
uniform bool left_right = false;
uniform float position = 0.3;
uniform float max_side = 8.0;
uniform float dense_area_width : hint_range(0.0, 24.0) = 0.3;
uniform float aspect_ratio = 1.77777;
uniform float offset : hint_range(0.0, 1.0) = 0.9;
uniform float falloff_distance : hint_range(0.0, 36.0) = 0.9;
uniform sampler2D lotus_texture: source_color, filter_nearest, repeat_enable;

vec2 hash_offset(vec2 inputvec, float dist) {
	inputvec = vec2(dot(inputvec, vec2(127.1, 311.7)), dot(inputvec, vec2(269.5, 183.3)));
	vec2 ofs = fract(sin(inputvec) * 43758.5453123);
	ofs -= (1.0/grid_scale) / 2.0;
	return ofs;
}

float hash_side(vec2 inputvec) {
	inputvec = fract(inputvec * vec2(123.34, 456.21));
	inputvec += dot(inputvec, inputvec + 45.32);
	return fract(inputvec.x * inputvec.y);
}

float hash_rotation(vec2 inputvec) {
	inputvec = fract(inputvec * vec2(256.34, 90.21));
	inputvec += dot(inputvec, inputvec + 32.32);
	return fract(inputvec.x * inputvec.y);
}

float calculate_distance(float pos, bool lr, vec2 input_vec)
{
	pos *= grid_scale;
	if (!lr) pos /= aspect_ratio;
	float delta = 0.0;
	if (lr) {
		delta = abs(pos - input_vec.x);
	}
	else {
		delta = abs(pos - input_vec.y);
	}
	if (delta < dense_area_width){
		delta = 0.0;	
	}
	else delta -= dense_area_width;
	return delta;
}

float calculate_side(float dist, float max_rad, vec2 input_vec)
{
	float delta = dist / falloff_distance;
	float one_min = 1.0 - delta;
	delta = min(1.0, 1.0 - delta / 1.0);
	return hash_side(input_vec) * max_rad * delta;
}


void fragment() {
	vec2 grid_uv = vec2(UV.x * grid_scale, UV.y * grid_scale / aspect_ratio);
	vec2 cell_id = floor(grid_uv);
	float current_hash_prio = 0.0;
	vec4 current_color = vec4(0,0,0,0);
	
	for(int x = -4; x <= 4; x++){
		for(int y = -4; y <= 4; y++){
			float xf = float(x);
			float yf = float(y);
			vec2 delta_cell_id = cell_id + vec2(xf, yf);
			float dist = calculate_distance(position, left_right, delta_cell_id);
			vec2 rnd_offset = hash_offset(delta_cell_id, dist) * offset;
			vec2 centerpoint = rnd_offset + delta_cell_id;
			vec2 local_position = grid_uv - centerpoint; 
			float side = calculate_side(dist, max_side, delta_cell_id);
			float rotation = hash_rotation(delta_cell_id);
			float prio = hash_side(delta_cell_id);
			if (prio > current_hash_prio){
				float s = sin(-rotation);
				float c = cos(-rotation);
				mat2 rot = mat2(vec2(c, s), vec2(-s, c));
				vec2 rotated = rot * local_position;
				float half_side = side * 0.5;
				if (abs(rotated.x) < half_side && abs(rotated.y) < half_side) {
					vec2 tex_uv = rotated / side + 0.5;
					vec4 color = texture(lotus_texture, tex_uv);
					if (color.a != 0.0)
					{
						current_color = color;
						current_hash_prio = prio;	
					}
				}
			} 
		}
	}
	COLOR = current_color;
}
