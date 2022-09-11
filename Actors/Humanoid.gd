extends Node3D


func _on_random_anim_trigger_timeout():
	if not $AnimationPlayer.is_playing():
#		if randf() < 0.5:
		$AnimationPlayer.play("mixamocom")
