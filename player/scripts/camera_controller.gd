@tool
extends Node3D

var look_dir : Vector2
var margin : float = 0.01


func _ready() -> void:
	%state_manager.connect("respawn", warp)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		%camera_yaw.rotation.y += -event.relative.x * 0.001
		%camera_pitch.rotation.x += -event.relative.y * 0.001
	look_dir = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	%camera_pitch.rotation.x = clamp(%camera_pitch.rotation.x, -PI/2 + margin, PI/2 - margin)

func _process(delta):
	%camera_yaw.global_position.x = lerp(global_position.x, %camera_yaw.global_position.x, exp(delta * -10))
	%camera_yaw.global_position.z = lerp(global_position.z, %camera_yaw.global_position.z, exp(delta * -10))
	if owner.is_on_floor():
		%camera_yaw.global_position.y = lerp(global_position.y, %camera_yaw.global_position.y, exp(delta * -15))
	elif $camera_yaw.global_position.y > global_position.y:
		%camera_yaw.global_position.y = lerp(global_position.y, %camera_yaw.global_position.y, exp(delta * -10))
	else:
		%camera_yaw.global_position.y = lerp(global_position.y, %camera_yaw.global_position.y, exp(delta * -2))
	%camera_yaw.rotation.y += look_dir.x * 5 * delta
	%camera_pitch.rotation.x += look_dir.y * 5 * delta
	%camera_pitch.rotation.x = clamp(%camera_pitch.rotation.x, -PI/2 + margin, PI/2 - margin)
	%camera.look_at(%camera_yaw.global_position)
	
func warp() -> void:
	%camera_yaw.global_position = global_position
