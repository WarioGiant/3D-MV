#Dead
extends BaseState

var respawn_timer : float

func enter() -> void:
	super()
	player.velocity *= Vector3(0,1,0)
	respawn_timer = 0.0
	player.camera_detach(true)

func loop(delta: float):
	#FALL
	player.velocity.y -= player.gravity * delta
	if player.velocity.y < 0:
		player.velocity.y -= player.gravity * delta * 2
	
	respawn_timer += delta
	if respawn_timer > 1.0:
		player.camera_detach(false)
		player.set_health(player.max_health)
		player.velocity = Vector3.ZERO
		player.checkpoint_position = player.respawn_position
		player.global_position = player.respawn_position
		
		%state_manager.emit_signal("respawn")
		return State.Idle
