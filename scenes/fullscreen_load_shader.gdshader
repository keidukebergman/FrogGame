shader_type canvas_item;
render_mode blend_mix;

uniform float grid_scale : hint_range(2.0, 60.0) = 20.0;
uniform bool left_right = false;
uniform float position = 0.3;
uniform float width = 0.3;
uniform float aspect_ratio = 1.77777;
uniform float offset : hint_range(0.0, 1.0) = 0.9;


void fragment() {
	vec2 grid_uv = vec2(UV.x * grid_scale, UV.y * grid_scale / aspect_ratio);
	vec2 cell_id = floor(grid_uv);
	COLOR = vec4(0,0,0,0);
	float best_delta = 9999999.0;
	float delta = 0.0;
	for(int x = -2; x <= 2; x++){
		for(int y = -2; y <= 2; y++){
			float xf = float(x);
			float yf = float(y);
			vec2 centerpoint = vec2(0.1, 0.1) + cell_id + vec2(xf, yf);
			if (distance(grid_uv, centerpoint) < width){
				delta = 1.0;
			} 
		}
	}
	float mask = 1.0 - smoothstep(0.0, 1, 1);
	COLOR = vec4(delta, delta, delta, delta);
}
