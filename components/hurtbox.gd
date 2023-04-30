class_name Hurtbox extends Area3D

@export var damage : int
@export var reset_to_checkpoint : bool = false
@export var damage_player : bool = true
@export var damage_enemy : bool = true

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body : Node3D):
	if body is Player and damage_player:
		body.take_damage(damage, reset_to_checkpoint)
	if body is Enemy and damage_enemy:
		body.take_damage(damage)
