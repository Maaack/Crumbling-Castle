extends "level.gd"
@export var doom_speed = 20.0
@export var gate_speed = 4.0
@onready var lose_area_2d = %LoseArea2D
@onready var gate = %Gate
@onready var gate_wall_label: Label = $World/Tower/GateWall/Label
@onready var debris_right: GPUParticles2D = $World/Tower/GateWall/DebrisRight
@onready var debris_left: GPUParticles2D = $World/Tower/GateWall/DebrisLeft
@onready var interact_input_hint = %InteractInputHint
@onready var jump_input_hint = %JumpInputHint
@onready var move_right_input_hint = %MoveRightInputHint
@onready var move_left_input_hint = %MoveLeftInputHint

var _gate_shake_intensity: float = 0

func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _ready() -> void:
	super._ready()
	open_tutorials()

func _on_lose_area_2d_body_entered(_node: Node2D) -> void:
	if _node.is_in_group(&"player"):
		level_lost.emit()

func _on_win_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		level_won.emit(next_level_path)

func _process(delta):
	lose_area_2d.position.y -= delta * doom_speed
	var shake: Vector2 = Vector2(randf() - .5, randf() - .5) * _gate_shake_intensity
	gate.label.offset_transform_position = shake
	gate_wall_label.offset_transform_position = shake
	debris_left.amount_ratio = clampf(_gate_shake_intensity, 0, 1)
	debris_right.amount_ratio = clampf(_gate_shake_intensity, 0, 1)
	_gate_shake_intensity = max(0, _gate_shake_intensity - delta * 10)

func _on_gate_wheel_wheel_turned():
	gate.position.y -= gate_speed
	_gate_shake_intensity = 10

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
