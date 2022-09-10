extends SubViewport

@export var cam_path : NodePath
var cam : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_node(cam_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	RenderingServer.global_shader_parameter_set("main_cam", cam.global_transform.origin)
#	%cam2.global_transform = cam.global_transform
#	%cam2.global_transform.origin += Vector3.UP * .01
