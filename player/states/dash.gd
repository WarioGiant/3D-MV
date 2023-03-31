#Dash
extends BaseState

func enter() -> void:
	player.velocity.y = 0

func loop(delta: float) -> int:
	player.velocity = lerp(player.velocity, Vector3.ZERO, delta * 10)
	var input_angle := Vector2(player.get_local_input_dir().z, player.get_local_input_dir().x).angle()
	player.body.rotation.y = lerp_angle(player.body.rotation.y, input_angle, delta * 10)
	
	#State Logic
	if Input.is_action_just_released("dash"):
		player.velocity = player.get_local_input_dir() * 135
		return State.Move
	return State.Null
