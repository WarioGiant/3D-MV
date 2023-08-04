#Fall
extends BaseState

var jump_time := 0.
var air_time := 0.

func enter() -> void:
	air_time = 0.
	


func loop(delta: float) -> int:
	
	#Falling
	player.velocity.y -= player.gravity * delta
	if player.velocity.y < 0:
		player.velocity.y -= player.gravity * delta * 2
	air_time += delta
	
	#Stop ascent when releasing jump
	if not Input.is_action_pressed("jump") and player.velocity.y > 0:
		player.velocity.y *= 0
	
	#Jump queuing
	if jump_time:
		jump_time -= delta
		jump_time = max(jump_time, 0)
	if Input.is_action_just_pressed("jump"):
		jump_time = 0.2
	
	#State Logic
	
	if player.is_on_floor():
		if jump_time and Input.is_action_pressed("jump"):
			return State.Jump
		if player.velocity.length() > 2:
			return State.Move
		return State.Idle
	if Input.is_action_pressed("grab") and player.is_on_wall_only() and player.velocity.y < 0 and player.abilities["grab"]:
		return State.Grab
	if Input.is_action_just_pressed("dash") and player.dashes:
		return State.Dash
		
	move(delta)
	if get_local_input():
		%body.rotation.y = lerp_angle(%body.rotation.y, get_input_angle(), delta * 10)
	return State.Null
