#Jump
extends BaseState

func loop(delta: float) -> int:
	player.velocity.y = player.jump_velocity
	return State.Fall
