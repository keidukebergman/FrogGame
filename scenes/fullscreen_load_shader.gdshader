shader_type canvas_item;
render_mode blend_mix;

uniform float grid_scale : hint_range(2.0, 60.0) = 20.0;
uniform bool left_right = false;
uniform float position = 0.3;
uniform float width = 0.3;
uniform float aspect = 1.77777;

void fragment() {
    COLOR = vec4(0,0,0,0);
	
	vec2 grid_uv = vec2(UV.x * grid_scale, UV.y * grid_scale / aspect);
	vec2 cell_id = floor(grid_uv);
	
	if (left_right == true){
		if (abs(UV.x - position) < width){
				COLOR = vec4(1,1,1,1);
		}
	}
	else {
		if (abs(UV.y - position) < width){
				COLOR = vec4(1,1,1,1);
		}
	}
}