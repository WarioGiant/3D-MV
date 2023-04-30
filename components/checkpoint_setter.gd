@tool
class_name CheckpointSetter extends Area3D

@export var checkpoint_marker : Marker3D


func _ready() -> void:
	add_child(Marker3D.new())
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var player : Player = body
		player.checkpoint_position = checkpoint_marker.global_position
