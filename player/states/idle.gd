#Idle
extends BaseState

func loop(delta: float) -> int:
	#State Logic
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	if Input.get_vector("left", "right", "forward", "backward").length():
		return State.Move
	if not player.is_on_floor():
		return State.Fall
	if Input.is_action_just_pressed("dash"):
		return State.Dash
	
	if player.velocity.length() > 0:
		player.velocity = Vector3.ZERO
	if player.speed > 5:
		player.speed = 5.
	return State.Null
