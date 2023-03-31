#Grab
extends BaseState

var grab_angle := 0.

func enter() -> void:
	player.velocity = Vector3.ZERO
	grab_angle = Vector2(player.get_wall_normal().z, player.get_wall_normal().x).angle() + PI

func loop(delta: float) -> int:
	player.body.rotation.y = lerp_angle(player.body.rotation.y, grab_angle, delta * 15)
	
	#State Logic
	if Input.is_action_just_pressed("dash"):
		return State.Dash
	if Input.is_action_just_pressed("jump"):
		player.velocity = player.get_wall_normal() * 27
		player.velocity.y = player.jump_velocity * 1.5
		player.speed = 9.
		return State.Fall
	if Input.is_action_just_released("grab"):
		return State.Fall
	return State.Null
