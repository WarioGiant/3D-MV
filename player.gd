extends CharacterBody3D

var gravity := 30.
var friction := 10.
var grabbed := false
var dashes := 1
var speed := 5.
const jump_velocity := 9.
var direction := Vector3.ZERO
var local_input_dir := Vector3.ZERO
var target_node : Node3D
var locked := false
var can_move := true
var gliding := false
var dash_charge_time := 0.
var jump_timer := 0.
var walking_time := 0.
var max_lock_distance := 30.
@onready var body = get_node("body")
@onready var camera_yaw = get_node("camera_yaw")
@onready var camera_pitch = get_node("camera_yaw/camera_pitch")
@onready var camera = get_node("camera_yaw/camera_pitch/spring/camera")

func handle_camera(delta) -> void:
#	if Input.is_action_just_pressed("lock_on"):
#		locked = !locked
#		if locked:
#			var possible_targets := get_tree().get_nodes_in_group("lockable")
#			var closest_target_distance = max_lock_distance
#			for possible_target in possible_targets:
#				var distance_to_possible_target = global_position.distance_to(possible_target.global_position)
#				if distance_to_possible_target >= max_lock_distance:
#					continue
#				if distance_to_possible_target < closest_target_distance:
#					closest_target_distance = distance_to_possible_target
#					target_node = possible_target
#			if target_node == camera_yaw:
#				locked = false
#	if locked:
#		var locked_yaw = atan2((global_position.x - target_node.global_position.x), (global_position.z - target_node.global_position.z))
#		var locked_pitch = lerp(-PI/3, 0.0, global_position.distance_to(target_node.global_position) / max_lock_distance)
#		body.rotation.y = lerp_angle(body.rotation.y, locked_yaw + PI, delta * 12)
#		camera_pitch.rotation.x = locked_pitch
#		camera_yaw.rotation.y = lerp_angle(camera_yaw.rotation.y, locked_yaw, delta * 5)
#		if global_position.distance_to(target_node.global_position) >= max_lock_distance: #Unlock if far away
#			locked = false
#			target_node = camera_yaw
#	else: #Not locked
	target_node = camera_yaw
	if local_input_dir.length():
		body.rotation.y = lerp_angle(body.rotation.y, atan2(local_input_dir.x, local_input_dir.z), delta * 12)
	camera.look_at(target_node.global_position)

func handle_sprinting(delta) -> void:
	if Vector2(velocity.x, velocity.z).length() > 4.5:
		walking_time += delta
	if Vector2(velocity.x, velocity.z).length() < 0.001 and walking_time:
		walking_time = 0
	if walking_time >= 0.75:
		speed = 9
	else:
		speed = 5

func jump(delta) -> void:
	if Input.is_action_just_pressed("jump"): #Queue jump
		jump_timer = 0.33
	if not Input.is_action_pressed("jump") and velocity.y > 0: #Stop moving up when releasing jump
		velocity.y = 0
	if jump_timer > 0:
		jump_timer -= delta
		jump_timer = max(jump_timer, 0)
	if is_on_floor():
		if Input.is_action_just_pressed("jump") or (jump_timer and Input.is_action_pressed("jump")):
			jump_timer = 0
			velocity.y = jump_velocity

func dash(delta) -> void:
	if is_on_floor() and not dashes:
		dashes = 1
	if Input.is_action_pressed("dash") and dashes:
		dash_charge_time += delta
		can_move = false
		walking_time = 0
		direction = Vector3.ZERO
		velocity.y = 0
		velocity = lerp(velocity, Vector3.ZERO, delta * 5)
	elif dash_charge_time and dashes:
		dash_charge_time = 0
		dashes -= 1
		velocity = local_input_dir * 135
		if velocity.length():
			walking_time = 1.0
		can_move = true
		gravity = 30.

func grab(delta) -> void:
	if Input.is_action_pressed("grab") and is_on_wall_only():
		dashes = 1
		if not grabbed and velocity.y < 0:
			velocity = Vector3.ZERO
			direction = Vector3.ZERO
			grabbed = true
			gravity = 0.0
			can_move = false
		if Input.is_action_just_pressed("jump"):
			can_move = true
			walking_time = 1.0
			velocity.y = jump_velocity * 1.5
			velocity += get_wall_normal() * 27
			gravity = 30.0
			grabbed = false
	else:
		can_move = true
		grabbed = false
		gravity = 30.0

func _process(delta) -> void:
	handle_camera(delta)

func _physics_process(delta) -> void:
	#Fall
	if not is_on_floor():
		if gliding:
			velocity.y -= 1 * delta
			velocity.y = max(velocity.y, -5)
		else:
			velocity.y -= gravity * delta
			if velocity.y <= 0:
				velocity.y -= gravity * delta * 2
	
	#Handle movement input and set direction
	var input_dir = Input.get_vector("left", "right", "forward", "backward").normalized()
	local_input_dir = camera_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	if can_move:
		direction = local_input_dir * speed
	
	#Glide
	if (is_on_floor() or grabbed) or (Input.is_action_just_pressed("glide") and gliding):
		gliding = false
		friction = 10.0
	elif Input.is_action_just_pressed("glide"):
		friction = 2.0
		gliding = true
	
	velocity.x = lerp(velocity.x, direction.x, delta * friction)
	velocity.z = lerp(velocity.z, direction.z, delta * friction)
		
	jump(delta)
	grab(delta)
	dash(delta)
	handle_sprinting(delta)
	
	
	move_and_slide()

func _on_area_3d_body_entered(_body):
	global_position = Vector3(0, 32, 0)
