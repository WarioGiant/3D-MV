extends Node3D

@export_range(0.0, 8.0, 2.0) var offset : float = 0.0

func _ready() -> void:
	start()

func start() -> void:
	if offset:
		await get_tree().create_timer(offset).timeout
		$AnimationPlayer.play("flip")
	else:
		$AnimationPlayer.play("flip")
