extends Node3D
@tool

@export var gradient_start: Color:
	get:
		return gradient_start
	set(val):
		gradient_start = val
		gradient_start_hsv = col_to_hsv(gradient_start)
		set_gradient_shader("gradient_start", gradient_start_hsv)
		
@export var gradient_end: Color:
	get:
		return gradient_end
	set(val):
		gradient_end = val
		gradient_end_hsv = col_to_hsv(gradient_end)
		set_gradient_shader("gradient_end", gradient_end_hsv)

var gradient_start_hsv: Vector3
var gradient_end_hsv: Vector3

func col_to_hsv(col: Color) -> Vector3:
	return Vector3(col.h, col.s, col.v)

func set_gradient_shader(name: String, val: Vector3):
	if is_instance_valid(self):
		if has_node("Cliff1") and is_instance_valid(get_node("Cliff1")):
			var mat: ShaderMaterial = $Cliff1.get_surface_override_material(0)
			mat.set_shader_uniform(name, val)
	else:
		print("Cliff is null")


#func rgb2hsv(c: Vector3) -> Vector3:
#	var K: Vector4 = Vector4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
#	var p: Vector4 = mix(Vector4(c.y, c.z, K.w, K.z), Vector4(c.y, c.z, K.x, K.y), step(c.y, c.z));
#	var q:Vector4 = mix(Vector4(p.xyw, c.r), Vector4(c.r, p.yzx), step(p.x, c.r));
#
#	var d: float = q.x - min(q.w, q.y);
#	var e: float = 1.0e-10;
#	return Vector3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);

#vec3 hsv2rgb(vec3 c)
#{
#    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
#    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
#    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
#}


func _process(delta):
	pass
