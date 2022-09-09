extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$HBoxContainer/TextureRect.texture = $HBoxContainer/SubViewportContainer/SubViewport.get_texture()
	#$HBoxContainer/TextureRect2.texture = $HBoxContainer/SubViewportContainer2/SubViewport.get_texture()
	#$HBoxContainer/SubViewportContainer2/SubViewport.debug_draw = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#var cam1 := true
func _process(delta):
	RenderingServer.global_shader_parameter_set("main_cam", %cam1.global_transform.origin)
	%cam2.global_transform = %cam1.global_transform
	%cam2.global_transform.origin += Vector3.UP * .01
	$UI/Control/FPS.text = str(Engine.get_frames_per_second())
#	var viewport1 : SubViewport = $HBoxContainer/SubViewportContainer/SubViewport as SubViewport
#	var viewport2 : SubViewport = $HBoxContainer/SubViewportContainer2/SubViewport as SubViewport
#	if cam1:
#		viewport1.render_target_update_mode = SubViewport.UPDATE_ONCE
#		RenderingServer.global_shader_parameter_set("other_cam", false)
#	else:
#		viewport2.render_target_update_mode = SubViewport.UPDATE_ONCE
#		RenderingServer.global_shader_parameter_set("other_cam", true)
#	cam1 = not cam1
#	$UI/Control/FPS.text = str(Engine.get_frames_per_second())
#	RenderingServer.global_shader_parameter_set("other_cam", false)
#	RenderingServer.force_draw()
#	await RenderingServer.frame_post_draw
#	#$HBoxContainer/TextureRect.texture = ImageTexture.create_from_image($HBoxContainer/SubViewportContainer/SubViewport.get_texture().get_image())
#	RenderingServer.global_shader_parameter_set("other_cam", true)
#	RenderingServer.force_draw()
#	await RenderingServer.frame_post_draw
	#$HBoxContainer/TextureRect2.texture = ImageTexture.create_from_image($HBoxContainer/SubViewportContainer2/SubViewport.get_texture().get_image())
