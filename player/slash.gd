extends MeshInstance3D

var speed : float = 6.0
var time : float = 0.0
var prog : float


func _process(delta: float) -> void:
	time += delta * speed
	
	prog = remap(time, 0,1, 0.3,-.75)
	
	set_instance_shader_parameter("prog", prog)
	if time > 1.0:
		queue_free()
