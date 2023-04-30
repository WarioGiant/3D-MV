class_name Elevator extends Node3D

@export_range(0, 100) var speed : float = 50
@export var top_marker : Marker3D
@export var bottom_marker : Marker3D
@export var platform : AnimatableBody3D
@export var button : Area3D
@export var location : locations
var moving := false

enum locations {
	bottom,
	top,
}

@onready var top_location := top_marker.global_position
@onready var bottom_location := bottom_marker.global_position

func _ready() -> void:
	button.connect("body_entered", _on_area_3d_body_entered)
	
func _physics_process(delta: float) -> void:
	if moving:
		match location:
			locations.top:
				platform.global_position = platform.global_position.move_toward(bottom_location, speed * delta)
				if platform.global_position.distance_to(bottom_location) < 0.1:
					moving = false
					location = locations.bottom
			locations.bottom:
				platform.global_position = platform.global_position.move_toward(top_location, speed * delta)
				if platform.global_position.distance_to(top_location) < 0.01:
					moving = false
					location = locations.top

func elevate():
	if location == locations.bottom:
		platform.global_position = platform.global_position.move_toward(top_location, speed)
		moving = true
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		moving = true
