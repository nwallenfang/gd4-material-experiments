extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport.debug_draw = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$SubViewportContainer/SubViewport.debug_draw += 1
