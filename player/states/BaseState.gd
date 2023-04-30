class_name BaseState extends Node

var player : Player

enum State {
	Null,
	Idle,
	Move,
	Fall,
	Dash,
	Grab,
	Jump,
	Swing,
	Attack,
	Dead,
}

@onready var animation_player = get_owner().get_node("AnimationPlayer")

func update_body_angle(delta: float) -> void:
	var input_angle := Vector2(get_local_input_dir().z, get_local_input_dir().x).angle()
	if input_angle:
		player.body.rotation.y = lerp_angle(player.body.rotation.y, input_angle, delta * 10)

func get_local_input_dir() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var local_input_dir = (player.camera_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return local_input_dir

func move(delta: float, speed_scale : float = 1.0) -> void:
	player.velocity.x = get_local_input_dir().x * player.speed * speed_scale
	player.velocity.z = get_local_input_dir().z * player.speed * speed_scale

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func loop(delta: float) -> int:
	return State.Null
