shader_type canvas_item;

uniform float shake_intensity = 0.0;
uniform float shake_speed = 20.0;

void vertex() {
	vec2 shake = vec2(0.0);
	
	// Because we want to apply shake from the top down and our sprite has the tallest part
	// when y is most negative bc godot is freaky
	if (VERTEX.y < 0.0) {
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	
	VERTEX.xy += shake;
}
