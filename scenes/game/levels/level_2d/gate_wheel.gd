extends Node2D

signal wheel_turned
signal player_entered
signal player_exited

enum WheelState{
	CARDINAL,
	DIAGONAL
}

@export var max_turns : int = 24
@onready var animation_player = %AnimationPlayer

var wheel_state : WheelState = WheelState.CARDINAL
var can_interact : bool = false
var turns : int = 0

func _turn_wheel() -> void:
	match wheel_state:
		WheelState.CARDINAL:
			wheel_state = WheelState.DIAGONAL
			animation_player.play(&"diagonal")
		WheelState.DIAGONAL:
			wheel_state = WheelState.CARDINAL
			animation_player.play(&"cardinal")
	wheel_turned.emit()

func turn_wheel() -> void:
	if turns >= max_turns:
		return
	turns += 1
	_turn_wheel()

func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.is_in_group(&"player"):
		can_interact = true
		player_entered.emit()

func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.is_in_group(&"player"):
		can_interact = false
		player_exited.emit()

func _input(event : InputEvent) -> void:
	if not can_interact:
		return
	if event.is_action_pressed(&"interact"):
		turn_wheel()
	elif event is InputEventMouseButton:
		if event.is_pressed() and \
		(event.button_index == MOUSE_BUTTON_WHEEL_UP \
		or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			turn_wheel()
