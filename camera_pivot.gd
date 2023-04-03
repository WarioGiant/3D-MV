extends Node3D

var look_dir : Vector2
@onready var camera_pitch := get_node("camera_pitch")
@onready var camera := get_node("camera_pitch/camera_spring/camera")
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.rotation.y += -event.relative.x * 0.001
		camera_pitch.rotation.x += -event.relative.y * 0.001
	look_dir = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	camera_pitch.rotation.x = clamp(camera_pitch.rotation.x, -PI/2 + 0.1, PI/2 - 0.1)

func _process(delta):
	self.rotation.y += look_dir.x * 5 * delta
	camera_pitch.rotation.x += look_dir.y * 5 * delta
	camera_pitch.rotation.x = clamp(camera_pitch.rotation.x, -PI/2 + 0.1, PI/2 - 0.1)
	camera.look_at(global_position)
