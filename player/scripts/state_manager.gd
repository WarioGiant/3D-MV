extends Node

@onready var player : Player = get_parent()
@onready var states = {
	BaseState.State.Idle: $idle,
	BaseState.State.Move: $move,
	BaseState.State.Fall: $fall,
	BaseState.State.Dash: $dash,
	BaseState.State.Grab: $grab,
	BaseState.State.Jump: $jump,
	BaseState.State.Hang: $hang,
	BaseState.State.Dead: $dead,
}

@export var current_state_node : BaseState
@export var previous_state_node : BaseState

signal respawn

func change_state(new_state: int) -> void:
	if current_state_node:
		current_state_node.exit()
	previous_state_node = current_state_node
	current_state_node = states[new_state]
	current_state_node.enter()
	player.get_node("label").text = current_state_node.name

func _ready() -> void:
	for child in get_children():
		child.player = player
	current_state_node = states[BaseState.State.Idle]
	change_state(BaseState.State.Idle)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var slash = load("res://player/slash.tscn").instantiate()
		add_child(slash)
		slash.global_position = player.global_position
		slash.rotation = %body.rotation
		
	if player.is_on_floor():
		player.reset_jumps_and_dashes()
	
	if player.health <= 0 and current_state_node != states[BaseState.State.Dead]:
		change_state(BaseState.State.Dead)
	
	var next_state : int = current_state_node.loop(delta)
	if next_state:
		change_state(next_state)
