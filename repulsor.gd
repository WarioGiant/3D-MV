extends Area3D


var overlapping_characters : Array[CharacterBody3D]

func _physics_process(_delta: float) -> void:
	overlapping_characters.assign(get_overlapping_bodies().filter(func(body): return body is CharacterBody3D))
	if overlapping_characters.size():
		for character in overlapping_characters:
			var direction_to_character = global_position.direction_to(character.global_position)
			var distance_to_character = global_position.distance_to(character.global_position)
			character.velocity += direction_to_character * 100 * (1/(distance_to_character*2))
