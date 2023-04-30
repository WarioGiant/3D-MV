class_name Enemy extends CharacterBody3D

@export var health := 5

func take_damage(damage : int) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	queue_free()
