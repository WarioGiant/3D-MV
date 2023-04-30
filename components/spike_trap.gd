extends Node3D

@export var period := 1.0
@export var time_offset := 0.0
@export var amplitude := 1.0

@onready var trap = $animatable_body

var time := 0.0
func _physics_process(delta: float) -> void:
	trap.position.y = sin((time + time_offset) * PI*2 / period) * amplitude
	time += delta

func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body is Player:
		var player : Player = body
		player.take_damage(1, true)
