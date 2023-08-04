extends Node3D

@export var speed := 1.0
@export var player : Player


func _process(delta: float) -> void:
	var dir_to_player = global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(Vector2(dir_to_player.z, dir_to_player.x).angle(), rotation.y, exp(delta*-3))
	position += dir_to_player * speed * Vector3(1,0,1) * delta
	$AnimationPlayer.speed_scale = speed
	speed = remap(1,200,0.01,1,global_position.distance_to(player.global_position))
