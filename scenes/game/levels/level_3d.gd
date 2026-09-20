extends "level.gd"

@export var doom_speed : float = 3.6

@onready var lose_area_3d = %LoseArea3D
@onready var character_body_3d = %CharacterBody3D

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
