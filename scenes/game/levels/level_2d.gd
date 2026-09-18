extends "level.gd"
@export var doom_speed = 20.0
@export var gate_speed = 4.0
@onready var lose_area_2d = %LoseArea2D
@onready var gate = %Gate
@onready var interact_input_hint = %InteractInputHint
@onready var jump_input_hint = %JumpInputHint
@onready var move_right_input_hint = %MoveRightInputHint
@onready var move_left_input_hint = %MoveLeftInputHint

func _on_lose_area_2d_body_entered(_node: Node2D) -> void:
	if _node.is_in_group(&"player"):
		level_lost.emit()

func _on_win_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		level_won.emit(next_level_path)

func _process(delta):
	lose_area_2d.position.y -= delta * doom_speed

func _on_gate_wheel_wheel_turned():
	gate.position.y -= gate_speed

func _on_gate_wheel_player_entered():
	interact_input_hint.show()

func _on_gate_wheel_player_exited():
	interact_input_hint.hide()

func _on_starting_area_2d_body_entered(_body):
	move_right_input_hint.show()
	move_left_input_hint.show()

func _on_starting_area_2d_body_exited(_body):
	move_right_input_hint.hide()
	move_left_input_hint.hide()

func _on_first_jump_area_2d_body_entered(_body):
	jump_input_hint.show()

func _on_first_jump_area_2d_body_exited(_body):
	jump_input_hint.hide()
