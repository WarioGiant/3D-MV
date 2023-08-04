extends Area3D

class_name FoliageEffect

@export var particles : PackedScene

var new_particles_instance : GPUParticles3D

func _ready() -> void:
	new_particles_instance = particles.instantiate()
	
	
func _on_body_entered_or_exited(body: Node3D) -> void:
	if body is CharacterBody3D or body is RigidBody3D:
		new_particles_instance = particles.instantiate()
		add_child(new_particles_instance)
		new_particles_instance.global_position = body.global_position + Vector3(0, 1, 0)

