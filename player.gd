class_name Player extends CharacterBody3D

var gravity := 30.
var speed = 5.
var dashes := 1
const jump_velocity := 9.

var direction := Vector3.ZERO
var local_input_dir := Vector3.ZERO


@onready var body : Node3D = get_node("body")
@onready var camera_yaw = get_node("camera_yaw")
@onready var camera_pitch = get_node("camera_yaw/camera_pitch")
@onready var camera = get_node("camera_yaw/camera_pitch/camera_spring/camera")

func get_local_input_dir() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	local_input_dir = camera_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	return local_input_dir
	
func move(delta: float, speed: float) -> void:
	direction = get_local_input_dir() * speed
	velocity.x = lerp(velocity.x, direction.x, delta * 10)
	velocity.z = lerp(velocity.z, direction.z, delta * 10)
	if direction:
		body.rotation.y = lerp_angle(body.rotation.y, atan2(local_input_dir.x, local_input_dir.z), delta * 12)

func _process(delta) -> void:
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack1")
		$AnimationPlayer.queue("RESET")
	body.rotation.y = wrapf(body.rotation.y, 0, 2 * PI)

func _physics_process(delta) -> void:
	move_and_slide()

func die(_body):
	global_position = Vector3(-5, 10, 0)
