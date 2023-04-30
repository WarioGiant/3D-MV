#Dash
extends BaseState

var dashing : bool

func enter() -> void:
	super()
	dashing = false
	player.dashes -= 1
	player.dashes = max(player.dashes, 0)
	player.velocity.y = 0

func loop(delta: float) -> int:
	update_body_angle(delta)
	player.velocity = lerp(player.velocity, Vector3.ZERO, delta * 10)
	#Dash
	if Input.is_action_just_released("dash") and not dashing:
		dashing = true
		player.velocity = get_local_input_dir() * 135
	if player.velocity.length() < player.speed and dashing:
		if player.is_on_floor():
			return State.Move
		else:
			return State.Fall
	return State.Null
