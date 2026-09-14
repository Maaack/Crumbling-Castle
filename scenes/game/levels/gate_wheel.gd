extends Node2D

signal wheel_turned

enum WheelState{
	CARDINAL,
	DIAGONAL
}

@onready var animation_player = %AnimationPlayer

var wheel_state : WheelState = WheelState.CARDINAL
var can_interact : bool = false

func turn_wheel() -> void:
	match wheel_state:
		WheelState.CARDINAL:
			wheel_state = WheelState.DIAGONAL
			animation_player.play(&"diagonal")
		WheelState.DIAGONAL:
			wheel_state = WheelState.CARDINAL
			animation_player.play(&"cardinal")
	wheel_turned.emit()

func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.is_in_group(&"player"):
		can_interact = true

func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.is_in_group(&"player"):
		can_interact = false

func _input(event : InputEvent) -> void:
	if not can_interact:
		return
	if event.is_action_pressed(&"interact"):
		turn_wheel()
		
