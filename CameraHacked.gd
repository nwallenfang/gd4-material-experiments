extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	%cam2.global_transform = global_transform
	%cam2.global_transform.origin += Vector3.UP * .02


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SubViewport.size = get_viewport().size
	RenderingServer.global_shader_parameter_set("main_cam", global_transform.origin)
	%cam2.global_transform = global_transform
	%cam2.global_transform.origin += Vector3.UP * .02
