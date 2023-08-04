extends Node3D

@export_range(0, 10) var offset : float = 0.0

var time : float = 0.0
var crushing : bool = false

func crush() -> void:
	crushing = true
	
func _ready() -> void:
	time += offset

func _physics_process(delta: float) -> void:
	time += delta
	if time >= 2.0:
		time = 0.0
		crush()
	if crushing:
		$AnimatableBody3D.position = lerp(Vector3(0, -7, 0), $AnimatableBody3D.position, exp(delta * -10))
		if $AnimatableBody3D.position.distance_to(Vector3(0, -7, 0)) < 0.05:
			crushing = false
			create_tween().tween_property($AnimatableBody3D, "position", Vector3.ZERO, 1)
#			$AnimatableBody3D.position = Vector3.ZERO
