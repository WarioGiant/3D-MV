#Dash
extends BaseState

var dashing : bool
var charge_time := 0.0
var dash_speed = 55
var jump_time := 0.0
var dash_time := 0.0
var big_dash := false
@onready var particles : GPUParticles3D = $"../../dash_particles"


func dash() -> void:
	dashing = true
	particles.emitting = true
	player.velocity = get_local_input().normalized() * dash_speed
	if player.velocity.length():
		animation_player.play("squish")


func enter() -> void:
	big_dash = false
	jump_time = 0.0
	dash_time = 0.0
	charge_time = 0.0
	dash_speed = 55
	dashing = false
	player.dashes -= 1
	player.dashes = max(player.dashes, 0)
	player.velocity.y = 0

func exit() -> void:
	particles.emitting = false
	if dashing:
		animation_player.play("unsquish")

func loop(delta: float) -> int:
	if get_local_input():
		%body.rotation.y = lerp_angle(%body.rotation.y, get_input_angle(), delta * 10)
	#Dash
	if dashing:
		#Jump queuerier
		if jump_time:
			jump_time = max(jump_time - delta, 0)
		if Input.is_action_just_pressed("jump"):
			jump_time = 0.5
			
		#Dash queueierer
		if dash_time:
			dash_time = max(dash_time - delta, 0)
		if Input.is_action_just_pressed("dash"):
			dash_time = 0.7
		
		if big_dash:
#			player.velocity = lerp(player.velocity, Vector3.ZERO, delta * 1.75)
			player.velocity = player.velocity.move_toward(Vector3.ZERO, 1.5)
		else:
#			player.velocity = lerp(player.velocity, Vector3.ZERO, delta * 6)
			player.velocity = player.velocity.move_toward(Vector3.ZERO, 4)
		if player.velocity.length() < player.speed * 1:
			if player.is_on_floor():
				if jump_time and Input.is_action_pressed("jump"):
					return State.Jump
				if dash_time:
					return State.Dash
				return State.Move
			else:
				if dash_time and player.dashes:
					return State.Dash
				return State.Fall
	else:
		player.velocity = lerp(player.velocity, Vector3.ZERO, delta * 10)
		if charge_time or not player.is_on_floor() or get_local_input():
			charge_time += delta
		if not Input.is_action_pressed("dash"):
			if get_local_input():
				dash()
			else:
				return State.Move
		if charge_time > 0.75:
			if player.abilities["big_dash"]:
				big_dash = true
				dash_speed = 80
			if get_local_input():
				dash()
			else:
				return State.Fall
	return State.Null
