shader_type spatial;

uniform vec4 primary_color : source_color;
uniform float roughness = 0.2;
uniform float alpha = 0.2;
uniform sampler2D normalmap_a : hint_normal;
uniform sampler2D normalmap_b : hint_normal;
uniform float normalmap_a_strength = 0.3;
uniform float normalmap_b_strength = 0.4;
uniform vec2 movement_direction = vec2(0.1,0.1);
uniform float movement_strength = 0.5;
uniform float uv_scale = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV * uv_scale;
	vec2 uv_movement = movement_direction * TIME * movement_strength;
	
	vec3 normalmap = texture(normalmap_a, uv + uv_movement).rgb * normalmap_a_strength;
	normalmap +=  texture(normalmap_b, uv - uv_movement).rgb * normalmap_b_strength;
	
	ALBEDO = primary_color.rgb;
	ROUGHNESS = roughness;
	NORMAL_MAP = normalmap;
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
