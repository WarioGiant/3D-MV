#Idle
extends BaseState

func loop(delta: float) -> int:
	#State Logic
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	if Input.get_vector("left", "right", "forward", "backward").length() or player.velocity.length() > 0.01:
		return State.Move
	if not player.is_on_floor():
		return State.Fall
	if Input.is_action_pressed("dash"):
		return State.Dash
	if Input.is_action_pressed("attack"):
		return State.Attack
	
	if player.velocity.length() > 0:
		player.velocity = Vector3.ZERO
	
	return State.Null
