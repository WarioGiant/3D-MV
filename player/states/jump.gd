#Jump
extends BaseState

func enter() -> void:
	super()
	if not player.is_on_floor():
		player.air_jumps = max(player.air_jumps - 1, 0)

func loop(delta: float) -> int:
	player.velocity.y = player.jump_velocity
	return State.Fall
