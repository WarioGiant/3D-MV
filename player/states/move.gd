#Move
extends BaseState

var local_input_dir := Vector3.ZERO
var walking_time := 0.

func enter():
	walking_time = 0.

func loop(delta: float) -> int:
	walking_time += delta
	if walking_time > 0.75:
		player.speed = 9.
	player.move(delta, player.speed)
	
	
	#State Logic
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	if not player.is_on_floor():
		return State.Fall
	if player.velocity.length() < 0.001:
		return State.Idle
	if Input.is_action_just_pressed("dash"):
		return State.Dash
		
	return State.Null
