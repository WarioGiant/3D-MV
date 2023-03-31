#Fall
extends BaseState

var jump_time := 0.

func loop(delta: float) -> int:
	
	player.move(delta, player.speed)
	
	#Gravity
	player.velocity.y -= player.gravity * delta
	if player.velocity.y < 0:
		player.velocity.y -= player.gravity * delta * 2
	
	#Stop ascent when releasing jump
	if not Input.is_action_pressed("jump") and player.velocity.y > 0:
		player.velocity.y = 0
	
	#Coyote Time
	if jump_time:
		jump_time -= delta
		jump_time = max(jump_time, 0)
	if Input.is_action_just_pressed("jump"):
		jump_time = 0.2
	
	#State Logic
	if player.is_on_floor():
		if jump_time and Input.is_action_pressed("jump"):
			return State.Jump
		return State.Idle
	if Input.is_action_pressed("grab") and player.velocity.y < 0 and player.is_on_wall_only():
		return State.Grab
	if Input.is_action_just_pressed("dash"):
		return State.Dash
	return State.Null
