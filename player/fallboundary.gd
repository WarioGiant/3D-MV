#FallBoundary
extends Hitbox

var prev_phys_global_position = Vector3.ZERO
var offset_from_player := -8.05
var target_y := 0.0
@onready var player : Player = get_parent()

func _ready() -> void:
	super()
	top_level = true
#	$MeshInstance3D.top_level = true
	%state_manager.connect("respawn", warp)

func _physics_process(delta: float) -> void:
	prev_phys_global_position = global_position
	if player.is_on_floor():
		target_y = player.global_position.y + offset_from_player
	global_position.y = move_toward(global_position.y, target_y, delta * 20)

func _process(_delta: float) -> void:
	$MeshInstance3D.global_position = lerp(prev_phys_global_position, global_position, Engine.get_physics_interpolation_fraction())

func warp() -> void:
	global_position.y = player.global_position.y + offset_from_player
	$MeshInstance3D.global_position = global_position
