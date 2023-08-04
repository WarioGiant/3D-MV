class_name Hitbox extends Area3D

@export var damage : int = 1
@export var reset_to_checkpoint : bool = false

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body : Node3D):
	if body is Player:
		print("DAM")
		body.take_damage(damage, reset_to_checkpoint)
