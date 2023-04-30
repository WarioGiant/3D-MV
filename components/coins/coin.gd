class_name Coin extends Area3D

@export var mesh : MeshInstance3D

enum types {
	silver10,
	gold50,
	blue100,
}
@export var type : types

var value : int = 10

func _ready() -> void:
	match type:
		types.silver10:
			value = 10
			mesh.mesh.material.albedo_color = Color8(255,255,255)
		types.gold50:
			value = 50
			mesh.mesh.material.albedo_color = Color8(255,255,0)
		types.blue100:
			value = 100
			mesh.mesh.material.albedo_color = Color8(0,0,255)
	
	
	if not Engine.is_editor_hint():
		connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		mesh.position.y = sin(GlobalTime.time * 2) * 0.05
		mesh.rotation.y = GlobalTime.time


func _on_body_entered(body: Node3D):
	if body is Player:
		body.add_coins(value)
		queue_free()
