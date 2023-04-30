class_name Player extends CharacterBody3D

var gravity := 30.
var speed = 9.
var dashes := 1
var max_air_jumps := 0
var air_jumps := max_air_jumps
var health := 5
var itime := 30
var itimer := 0
var checkpoint_position = Vector3.ZERO
var respawn_position = Vector3.ZERO
var money := 0
const jump_velocity := 11


@export var abilities := {
	"attack" : true,
	"dash" : true,
	"glide" : true,
	"grab" : true,
	"ground_pound" : true,
}

@onready var body : Node3D = get_node("body")
@onready var camera_yaw = get_node("camera_yaw")
@onready var camera_pitch = get_node("camera_yaw/camera_pitch")
@onready var camera = get_node("camera_yaw/camera_pitch/camera")
@onready var health_bar : TextureProgressBar = get_node("camera_yaw/camera_pitch/camera/VBoxContainer/health_bar")
@onready var coin_counter : Label = get_node("camera_yaw/camera_pitch/camera/VBoxContainer/coin_counter")

func reset_jumps_and_dashes() -> void:
	air_jumps = max_air_jumps
	dashes = 1
	

func _ready() -> void:
	checkpoint_position = global_position
	respawn_position = global_position

func _process(delta) -> void:
#	if Vector2(velocity.x, velocity.z).length() > 0.1:
#		body.rotation.y = lerp_angle(body.rotation.y, Vector2(velocity.x, -velocity.z).angle() + PI/2, delta * 10)
	body.rotation.y = wrapf(body.rotation.y, 0, 2 * PI)
	
func _physics_process(delta) -> void:
	move_and_slide()
	if itimer: itimer-=1

func take_damage(damage : int, reset_to_checkpoint := false):
	if itimer and (not reset_to_checkpoint):
		return
	set_health(health - damage)
	if reset_to_checkpoint and health > 0:
		global_position = checkpoint_position
	itimer = itime
	
func detach_camera(detach : bool):
	if detach:
		camera_yaw.top_level = true
	else:
		camera_yaw.top_level = false
		camera_yaw.position = Vector3(0, 1.5, 0)
		camera_yaw.rotation = Vector3(0, PI, 0)
		
func add_coins(value : int):
	money += value
	coin_counter.text = str(money)

func set_health(new_health : int):
	health = new_health
	health_bar.value = health
