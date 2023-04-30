#Dead
extends BaseState

var respawn_timer : float
func enter() -> void:
	super()
	respawn_timer = 0.0
	player.detach_camera(true)
	player.velocity = Vector3.ZERO

func loop(delta: float):
	respawn_timer += delta
	if respawn_timer > 1.0:
		player.detach_camera(false)
		player.set_health(5)
		player.velocity = Vector3.ZERO
		player.global_position = player.respawn_position
		return State.Idle
