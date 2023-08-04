class_name AutoElevator extends Node3D

@export var speed : float
@export var body : AnimatableBody3D
@export var stop1 : Marker3D
@export var stop2 : Marker3D

var next_stop := 2

func _ready() -> void:
	body.global_position = stop1.global_position

func _physics_process(delta: float) -> void:
	match next_stop:
		1:
			body.global_position = body.global_position.move_toward(stop1.global_position, speed * delta)
			if body.global_position.distance_to(stop1.global_position) < 0.01:
				next_stop = 2
		2:
			body.global_position = body.global_position.move_toward(stop2.global_position, speed * delta)
			if body.global_position.distance_to(stop2.global_position) < 0.01:
				next_stop = 1
