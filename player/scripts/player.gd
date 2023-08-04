class_name Player extends CharacterBody3D

var gravity := 30.
var speed = 11.
var dashes := 1
var health := 5
var max_health := 5
var checkpoint_position = Vector3.ZERO
var respawn_position = Vector3.ZERO
var money := 0
const jump_velocity := 12 #prev 11


@export var abilities := {
	"big_dash" : false,
	"glide" : true,
	"grab" : true,
	"ground_pound" : true,
	"double_jump" : false
}

@onready var health_bar : TextureProgressBar = get_node("%camera_yaw/%camera_pitch/%camera/VBoxContainer/health_bar")
@onready var coin_counter : Label = get_node("%camera_yaw/%camera_pitch/%camera/VBoxContainer/coin_counter")
@onready var prev_phys_global_position := global_position

func reset_jumps_and_dashes() -> void:
	if dashes < 1:
		dashes = 1

func _ready() -> void:
	checkpoint_position = global_position
	respawn_position = global_position

func _physics_process(_delta) -> void:
	##DEBUG TOOL
	if Input.is_action_pressed("debug"):
		speed = 50
		gravity = 0
	else:
		speed = 9
		gravity = 30
	##DEBUG TOOL
		
		
	prev_phys_global_position = global_position
	move_and_slide()
	
func _process(_delta) -> void:
	if abs(velocity.y) > 50:
		floor_max_angle = deg_to_rad(10)
	else:
		floor_max_angle = deg_to_rad(45.1)
#	if Vector2(velocity.x, velocity.z).length() > 0.1:
#		%body.rotation.y = lerp_angle(%body.rotation.y, Vector2(velocity.x, -velocity.z).angle() + PI/2, delta * 10)
	%body.rotation.y = wrapf(%body.rotation.y, 0, 2 * PI)
	%body.global_position = lerp(prev_phys_global_position, global_position, Engine.get_physics_interpolation_fraction())
	RenderingServer.global_shader_parameter_set("PLAYER_BODY_GLOBAL_POSITION", %body.global_position)

func take_damage(damage : int, reset_to_checkpoint := false):
	change_health(-damage)
	if reset_to_checkpoint and health > 0:
		global_position = checkpoint_position
		%state_manager.emit_signal("respawn")
		
func camera_detach(detach : bool):
	if detach:
		%camera_controller.top_level = true
	else:
		%camera_controller.top_level = false
		%camera_controller.position = Vector3(0, 1.75, 0)
#		%camera_controller.rotation = Vector3(0, PI, 0)
		%camera_controller.warp()
		
func add_coins(value : int):
	money += value
	coin_counter.text = str(money)

func change_health(health_offset : int):
	health += health_offset
	health_bar.value = health
	
func set_health(new_health : int):
	health = new_health
	health_bar.value = health
