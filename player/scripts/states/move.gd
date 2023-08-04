#Move
extends BaseState

func loop(delta: float) -> int:
	
	
	#State Logic
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	if not player.is_on_floor():
		return State.Fall
	if player.velocity.length() < 0.01 and not Input.get_vector("left", "right", "forward", "backward").length():
		return State.Idle
	if Input.is_action_just_pressed("dash"):
		return State.Dash
	move(delta)
	if get_local_input():
		%body.rotation.y = lerp_angle(%body.rotation.y, get_input_angle(), delta * 10)
	return State.Null
