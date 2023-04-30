#Move
extends BaseState

func loop(delta: float) -> int:
	update_body_angle(delta)
	move(delta)
	
	#State Logic
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	if not player.is_on_floor():
		return State.Fall
	if player.velocity.length() < 0.01 and not Input.get_vector("left", "right", "forward", "backward").length():
		return State.Idle
	if Input.is_action_pressed("dash"):
		return State.Dash
	if Input.is_action_pressed("attack"):
		return State.Attack
	
	return State.Null
