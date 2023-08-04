#Jump
extends BaseState

func enter() -> void:
	super()
	player.velocity.y = player.jump_velocity
	if %state_manager.previous_state_node.name == "fall":
		if %state_manager.previous_state_node.air_time > 0.4 and player.abilities["double_jump"]:
			player.velocity.y = player.jump_velocity * 1.6

func loop(_delta: float) -> int:
	return State.Fall
