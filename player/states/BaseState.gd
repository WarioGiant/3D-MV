class_name BaseState extends Node

var player : Player

enum State {
	Null,
	Idle,
	Move,
	Fall,
	Dash,
	Grab,
	Jump,
}


func enter() -> void:
	pass
	
func exit() -> void:
	pass

func loop(delta: float) -> int:
	return State.Null
