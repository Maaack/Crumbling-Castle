extends "level.gd"

@export var doom_speed : float = 3.6
@export var gate_speed : float = 1.0

@onready var lose_area_3d = %LoseArea3D
@onready var character_body_3d = %CharacterBody3D
@onready var interact_input_hint_3d = %InteractInputHint3D
@onready var gate_3d = %Gate3D

func _on_lose_area_3d_body_entered(_body: Node3D) -> void:
	var tween = create_tween()
	tween.tween_property(character_body_3d, ^"world_time", 0.25, 0.5)
	level_lost.emit()

func _on_win_area_3d_body_entered(_body: Node3D) -> void:
	var tween = create_tween()
	tween.tween_property(character_body_3d, ^"world_time", 0.25, 0.5)
	level_won.emit(next_level_path)

func _process(delta):
	var doom_frame_offset = delta * doom_speed
	lose_area_3d.position.y += doom_frame_offset

func _on_gate_wheel_3d_player_entered():
	interact_input_hint_3d.show()

func _on_gate_wheel_3d_player_exited():
	interact_input_hint_3d.hide()

func _on_gate_wheel_3d_wheel_turned():
	gate_3d.position.y += gate_speed
	var tween: Tween = create_tween()
	#tween.tween_interval(2.0)
	#tween.tween_callback(dust_cloud.emit)
	#tween.tween_interval(0.5)
	#tween.tween_callback(dust_cloud_2.emit)
