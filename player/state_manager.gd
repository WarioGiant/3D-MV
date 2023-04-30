extends Node

@onready var player = get_parent()
@onready var states = {
	BaseState.State.Idle: $idle,
	BaseState.State.Move: $move,
	BaseState.State.Fall: $fall,
	BaseState.State.Dash: $dash,
	BaseState.State.Grab: $grab,
	BaseState.State.Jump: $jump,
	BaseState.State.Swing: $swing,
	BaseState.State.Dead: $dead,
	BaseState.State.Attack: $attack,
}

var current_state_node : BaseState

func change_state(new_state: int) -> void:
	if current_state_node:
		current_state_node.exit()
	states[new_state].enter()
	current_state_node = states[new_state]
	player.get_node("label").text = current_state_node.name
	if player.is_on_floor():
		player.reset_jumps_and_dashes()

func _ready() -> void:
	for child in get_children():
		child.player = player
	change_state(BaseState.State.Idle)

func _physics_process(delta: float) -> void:
	if player.health <= 0 and current_state_node != states[BaseState.State.Dead]:
		change_state(BaseState.State.Dead)
	var new_state : int = current_state_node.loop(delta)
	if new_state:
		change_state(new_state)
