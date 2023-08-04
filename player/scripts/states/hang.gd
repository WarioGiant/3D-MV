#Hang
extends BaseState

func enter() -> void:
	player.velocity = Vector3.ZERO

func loop(_delta: float) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	return State.Null
