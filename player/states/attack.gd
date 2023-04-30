#Attack
extends BaseState

var combo : int

func punch():
	var nearest_near_enemy : Enemy = %sensor.get_nearest_near_enemy()
	if nearest_near_enemy:
		var direction_to_nearest_enemy : Vector3 = player.body.global_position.direction_to(nearest_near_enemy.global_position)
		player.body.rotation.y = Vector2(direction_to_nearest_enemy.z, direction_to_nearest_enemy.x).angle()
	animation_player.clear_queue()
	match combo:
		1:
			animation_player.queue("right")
		2:
			animation_player.queue("left")
	combo += 1
	if combo > 2:
		combo = 1


func enter() -> void:
	combo = 1
	player.velocity = Vector3.ZERO
	punch()

func exit() -> void:
	animation_player.play("RESET")

func loop(delta: float) -> int:
	move(delta, 0.2)
	if Input.is_action_just_pressed("attack"):
		punch()
	if not animation_player.is_playing():
		if Input.is_action_pressed("attack"):
			punch()
		else:
			return State.Idle
	if not player.is_on_floor():
		return State.Fall
	return State.Null
