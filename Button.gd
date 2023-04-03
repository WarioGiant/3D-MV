extends Button

func _ready() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
