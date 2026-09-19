extends "level.gd"
@export var doom_speed = 20.0
@export var gate_speed = 4.0
@onready var lose_area_2d = %LoseArea2D
@onready var gate = %Gate
@onready var interact_input_hint = %InteractInputHint
@onready var jump_input_hint = %JumpInputHint
@onready var move_right_input_hint = %MoveRightInputHint
@onready var move_left_input_hint = %MoveLeftInputHint
@onready var first_checkpoint_marker_2d = %FirstCheckpointMarker2D
@onready var second_checkpoint_marker_2d = %SecondCheckpointMarker2D
@onready var third_checkpoint_marker_2d = %ThirdCheckpointMarker2D
@onready var character_body_2d = %CharacterBody2D

func _on_lose_area_2d_body_entered(_node: Node2D) -> void:
	if _node.is_in_group(&"player"):
		level_state.deaths += 1
		GlobalState.save()
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

func _on_first_checkpoint_area_2d_2_body_entered(_body):
	if level_state.checkpoints < 1:
		level_state.checkpoints = 1
		GlobalState.save()

func _on_second_checkpoint_area_2d_body_entered(_body):
	if level_state.checkpoints < 2:
		level_state.checkpoints = 2
		GlobalState.save()

func _on_third_checkpoint_area_2d_body_entered(body):
	if level_state.checkpoints < 3:
		level_state.checkpoints = 3
		GlobalState.save()

func _ready() -> void:
	super._ready()
	if level_state.checkpoints == 1:
		character_body_2d.global_position = first_checkpoint_marker_2d.global_position
	elif level_state.checkpoints == 2:
		character_body_2d.global_position = second_checkpoint_marker_2d.global_position
	elif level_state.checkpoints == 3:
		character_body_2d.global_position = third_checkpoint_marker_2d.global_position
