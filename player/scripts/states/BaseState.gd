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
	Hang,
	Dead,
}

@onready var animation_player : AnimationPlayer = get_owner().get_node("AnimationPlayer")


func get_local_input() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var local_input_dir = (%camera_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()
	return local_input_dir

func get_input_angle() -> float:
	return Vector2(get_local_input().z, get_local_input().x).angle() + PI

func move(delta: float, speed_scale : float = 1.0) -> void:
	var y_velocity : float = player.velocity.y
	player.velocity = lerp(player.velocity, get_local_input() * player.speed * speed_scale, delta * 15)
	player.velocity.y = y_velocity
	
func enter() -> void:
	pass
	
func exit() -> void:
	pass

func loop(_delta: float) -> int:
	return State.Null
