extends Node

@onready var player = get_parent()
@onready var states = {
	BaseState.State.Idle: $idle,
	BaseState.State.Move: $move,
	BaseState.State.Fall: $fall,
	BaseState.State.Dash: $dash,
	BaseState.State.Grab: $grab,
	BaseState.State.Jump: $jump,
}

var current_state_node : BaseState

func change_state(state: int):
	if current_state_node:
		current_state_node.exit()
	current_state_node = states[state]
	player.get_node("label").text = current_state_node.name
	current_state_node.enter()

func _ready() -> void:
	for child in get_children():
		child.player = player
	change_state(BaseState.State.Idle)

func _physics_process(delta: float) -> void:
	var new_state : int = current_state_node.loop(delta)
	if new_state:
		change_state(new_state)
