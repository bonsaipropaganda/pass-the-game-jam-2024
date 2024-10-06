shader_type canvas_item;

uniform vec3 hit_color: source_color = vec3(1,1,1);
uniform float amount: hint_range(0.0, 1.0, 0.05) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, hit_color, amount);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
