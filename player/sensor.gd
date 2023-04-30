extends Area3D


func get_nearest_near_enemy() -> Enemy:
	var enemies : Array[Node3D] = get_overlapping_bodies().filter(func(body): return body is Enemy)
	if enemies.size():
		var nearest_enemy : Enemy = enemies[0]
		for enemy in enemies:
			if global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy
		return nearest_enemy
	else:
		return null
